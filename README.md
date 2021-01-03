# study-ansible

My Ansible study on AWS instances provisioned by Terraform.

The infrastructure for Ansible study is created in AWS EC2 cloud service using Terraform.

Terraform also generates `inventory.ini` file and deploys public SSH key for Ansible for further playbook calls.

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

* copy env-vars setup script from versioned example to gitignored file;

    ```bash
    cp ./secrets.sh.example ./secrets.sh
    ```

* fill `secrets.sh` with personal data;
* every work session should be started from the script call to setup the env (in the same terminal as Terraform will be run)

    ```bash
    source ./secrets.sh
    ```

## single-vm

Single virtual machine experiments. A working directory should be `single-vm`

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

* Run!

    ```bash
    terraform apply
    ```

**DO NOT FORGET TO STOP** the instances after the work using (to save a AWS budget)

```bash
terraform destroy
```

---

### Ad-hoc: ping

To check the host availability

```bash
$ ansible -i inventory.ini vms -m ping
sandbox | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### Ad-hoc: simple shell command

Run simple shell command

```bash
$ ansible -i inventory.ini vms -a "free -m"
sandbox | CHANGED | rc=0 >>
              total        used        free      shared  buff/cache   available
Mem:            953         158         231           0         562         654
Swap:             0           0           0
```
