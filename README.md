# study-ansible

My Ansible study on AWS instances provisioned by Terraform.

The infrastructure for Ansible study is created in AWS EC2 cloud service using Terraform.

Terraform also generates `inventory.ini` file and deploys public SSH key for Ansible for further playbook calls.

## TODO

Some minor TODO's are placed directly in sources with `TODO:` comments.

### Ansible

* `command` vs `shell` examples;
* `include_*` vs `import_*` examples;
* Assign `ansible_ssh_user` depending on OS family smarter than manual groups usage.

### Terraform

* Create a non-default user on instances (but the same on Ubuntu and Amazon Linux).
* Think how to optimize Terraform sources and service files between multiple directories.
  * Maybe something like `terraform apply web-app-group/` could be called from the project root dir?
* Maybe instead a scalar variables some data structures could be used?

## Requirements

To setup the environment and run playbooks (the actual versions I used are listed below)

* get Linux/Unix system (I use [Debian in WSL](https://github.com/and1er/wsl-debian-settings)), Ansible cannot work properly on pure Windows;
* get AWS user access key pair from [AWS account](https://aws.amazon.com/), [IAM service](https://console.aws.amazon.com/iam/home);
* [install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html);

    ```bash
    $ ansible --version
    ansible 2.9.12
    ...
    python version = 3.7.3 (default, Jul 25 2020, 13:03:44) [GCC 8.3.0]
    ```

* [install Terraform](https://www.terraform.io/downloads.html);

    ```bash
    $ terraform --version
    Terraform v0.14.2
    ```

* setup an working envronment
  * copy env-vars setup script from versioned example to gitignored file;

    ```bash
    cp ./secrets.sh.example ./secrets.sh
    ```

  * fill `secrets.sh` with personal data;
  * every work session should be started from the script call to setup the env (in the same terminal as Terraform will be run)

    ```bash
    source ./secrets.sh
    ```

* or you could setup the variables manually in the terminal but _do not forget to add a whitespace before the command to make the command ignored by a shell command history_ like this

    ```bash
    # Here is a space before `export`
     export AWS_SECRET_ACCESS_KEY="my very secret key"
    ```

## Workspaces

* **single-vm** -- one EC2 Ubuntu 20.04 (Focal) instance;
* **web-app-group** -- multi-instance EC2 group of hosts:
  * 1 x web (a load balancer): Amazon Linux 2.0 (RedHat OS family);
  * 2 x app: Ubuntu 20.04 (Focal);
  * 1 x db: Ubuntu 20.04 (Focal).

## Launch Instances

Select a workspace, e.g. `single-vm`

```bash
cd ./single-vm
```

* First of all setup the env-vars.

    ```bash
    source ../secrets.sh
    ```

* Then init Terraform the working copy project.

    ```bash
    terraform init
    ```

Ready to work!

* Review what Terraform is going to do.

    ```bash
    terraform plan
    ```

* Launch!

    ```bash
    terraform apply
    ```

**DO NOT FORGET TO STOP** the instances after the work using (to save a AWS budget)

```bash
terraform destroy
```

If your private SSH-key is passphrase secured you could add the key to the current `bash` session and enter the passphrase once like this

```bash
ssh-agent bash
ssh-add /path/to/private.key
```

## Ansible plays

Go back to project root and call Ansible commands passing a path to generated `inventory.ini` file.

### Ad-hoc: ping

To check the hosts availability

```bash
$ ansible -i single-vm/inventory.ini vms -m ping

sandbox | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

```bash
$ ansible -i web-app-group/inventory.ini vms -m ping
app-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
app-2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
web-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
db-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### Ad-hoc: simple shell command

Run simple shell command (implicit `shell` or `command` module usage?).

* get free RAM:

    ```bash
    $ ansible -i single-vm/inventory.ini vms -a "free -m"

    sandbox | CHANGED | rc=0 >>
                total        used        free      shared  buff/cache   available
    Mem:            953         158         231           0         562         654
    Swap:             0           0           0
    ```

* view disk usage:

    ```bash
    $ ansible -i single-vm/inventory.ini vms -a "df -h"

    sandbox | CHANGED | rc=0 >>
    Filesystem      Size  Used Avail Use% Mounted on
    /dev/root       7.7G  1.3G  6.5G  17% /
    devtmpfs        473M     0  473M   0% /dev
    tmpfs           477M     0  477M   0% /dev/shm
    tmpfs            96M  764K   95M   1% /run
    tmpfs           5.0M     0  5.0M   0% /run/lock
    tmpfs           477M     0  477M   0% /sys/fs/cgroup
    /dev/loop0       33M   33M     0 100% /snap/amazon-ssm-agent/2996
    /dev/loop1       56M   56M     0 100% /snap/core18/1932
    /dev/loop2       68M   68M     0 100% /snap/lxd/18150
    /dev/loop3       32M   32M     0 100% /snap/snapd/10492
    tmpfs            96M     0   96M   0% /run/user/1000
    ```

* Python version (Amazon Linux and Ubuntu are different):

    ```bash
    $ ansible -i web-app-group/inventory.ini vms -a "python3 -V"
    app-2 | CHANGED | rc=0 >>
    Python 3.8.5
    app-1 | CHANGED | rc=0 >>
    Python 3.8.5
    web-1 | FAILED | rc=2 >>
    [Errno 2] No such file or directory
    db-1 | CHANGED | rc=0 >>
    Python 3.8.5

    $ ansible -i web-app-group/inventory.ini vms -a "python -V"
    app-2 | FAILED | rc=2 >>
    [Errno 2] No such file or directory: b'python'
    db-1 | FAILED | rc=2 >>
    [Errno 2] No such file or directory: b'python'
    app-1 | FAILED | rc=2 >>
    [Errno 2] No such file or directory: b'python'
    web-1 | CHANGED | rc=0 >>
    Python 2.7.18
    ```

### Ad-hoc: fork control

`-f` option sets a number of maximum forks for parallel tasks execution (default is `5`).

If set to `1` every call's play order will be the same (but slower of course)

```bash
ansible -i web-app-group/inventory.ini vms -m ping -f 1
```

### Ad-hoc: host facts

An example of host's Ansible facts is committed to `web-1-facts.json` file, got this way:

```bash
ansible -i web-app-group/inventory.ini web-1 -m setup > web-app-group/fetched/web-1-amazon-linux-facts.json

ansible -i web-app-group/inventory.ini db-1 -m setup > web-app-group/fetched/db-1-ubuntu-facts.json
```

Note: personal public IPv4 address was removed from `ansible_env.SSH_CLIENT` and `ansible_env.SSH_CONNECTION` facts.

### Ad-hoc: call a module with parameters

Example: install `vim` package using `apt`.

```bash
$ ansible -i web-app-group/inventory.ini web-1 -b -m apt -a "name=vim state=present update_cache=yes"
web-1 | SUCCESS => {
    "cache_update_time": 1609882860,
    "cache_updated": true,
    "changed": false
}
```
