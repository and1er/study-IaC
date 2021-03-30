study-IaC
=============

My Infrastructure as a Code instruments study using different infrastructure providers and Ansible as a configuration management tool (may be Chef/Puppet/Salt also will be considered in the future).

TODO's are in [TODO.md](./TODO.md).

Infrastructure
-----------------------

For study I use the same group of web application hosts

* 1 x **web** (a load balancer): (RedHat OS family);
* 2 x **app**: Ubuntu 20.04 (Focal);
* 1 x **db**: Ubuntu 20.04 (Focal).

created by different providers:

* Local Vagrant Environment: [infrastructure/vagrant-vbox/README.md](./infrastructure/vagrant-vbox/README.md).
* Cloud Teraform AWS instances: [infrastructure/terraform-aws/README.md](./infrastructure/terraform-aws/README.md).

Requirements
--------------

Linux/Unix system. I use Windows 10 as workstation with
* [Debian in WSL](https://github.com/and1er/wsl-debian-settings);
* and [Ubuntu 20.04](https://github.com/and1er/ubuntu-ws) VirtualBox VM.

Infrastructure providers:

* [Vagrant Requrements](./infrastructure/vagrant-vbox/README.md#Requirements).
* [Terraform AWS Requirements](./infrastructure/terraform-aws/README.md#Requirements).

Configuration managers:

* [Ansible Requirements](./configuration/ansible/README.md#Requirements).

Study Ansible
-----------------

[See](./configuration/ansible/README.md)
