TODO
============

Some minor TODO's are placed directly in sources with `TODO STUDY:` comments.

Vagrant
-------------

* Generate Ansible inventory file at `vagrant up` instead of static `infrastructure/vagrant-vbox/inventory.ini` file.
* Add and index to `db` host as in Terraform (could be `db1` and `db2` in the future).

Terraform
----------------

* Repair after project refactoring.
* Set the same env as in Vagrant.
* Create a non-default user on instances (but the same on Ubuntu and Amazon Linux).
* Think how to optimize Terraform sources and service files between multiple directories.
  * Maybe something like `terraform apply web-app-group/` could be called from the project root dir?
* Maybe instead a scalar variables some data structures could be used?

Ansible
-------------

* `command` vs `shell` examples;
* `include_*` vs `import_*` examples;
* Assign `ansible_ssh_user` depending on OS family smarter than manual groups usage.
