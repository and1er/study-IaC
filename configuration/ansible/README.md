# Study Ansible

## Requirements

I run Ansible 2.9 from WSL

```bash
$ ansible --version
ansible 2.9.19
...
python version = 3.7.3 (default, Jul 25 2020, 13:03:44) [GCC 8.3.0]
```

or Ubuntu in Virtual Environment

```bash
ansible 2.9.19
...
python version = 3.8.5 (default, Jan 27 2021, 15:41:15) [GCC 9.3.0]
```

## Installation

[Official Documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). I prefer to install Ansible to python virtual environment like this: [ubuntu-ws#ansible-installation](https://github.com/and1er/ubuntu-ws#ansible-installation)

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

Example: install `vim` package using `package` module (which automatically selects `apt` for Debian OS family and `yum` for RedHat OS family).

`-b` option means "become" (as sudo user).

```bash
$ ansible -i web-app-group/inventory.ini vms -b -m package -a "name=vim state=present update_cache=yes"
web-1 | SUCCESS => {
    "changed": false,
    "msg": "",
    "rc": 0,
    "results": [
        "2:vim-enhanced-8.1.1602-1.amzn2.x86_64 providing vim is already installed"
    ]
}
app-2 | SUCCESS => {
    "cache_update_time": 1609962833,
    "cache_updated": true,
    "changed": false
}
db-1 | SUCCESS => {
    "cache_update_time": 1609962833,
    "cache_updated": true,
    "changed": false
}
app-1 | SUCCESS => {
    "cache_update_time": 1609962833,
    "cache_updated": true,
    "changed": false
}
```
