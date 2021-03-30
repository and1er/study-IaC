Local Vagrant Environment
================================

For local provisioning I use Vagrant.

Requirements
------------------

I run Vagrant on Windows in Powershell to avoid nested virtualization.

```powershell
PS > vagrant --version
Vagrant 2.2.14
```

with VirtualBox 6.1.18.

Also `infrastructure\vagrant-vbox\authorized_keys.example` should be copied to `infrastructure\vagrant-vbox\authorized_keys` and fill by own public keys.

Commands
---------

VM names are

* `web`
* `app1`
* `app2`
* `db`

To manage them all `vagrant` commands without name

```powershell
PS .\infrastructure\vagrant-vbox> vagrant up
```

or to work with one

```powershell
PS .\infrastructure\vagrant-vbox> vagrant up web
```
