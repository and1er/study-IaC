# study-ansible

My Ansible study on AWS instances provisioned by Terraform.

The infrastructure for Ansible study is created in AWS EC2 cloud service using Terraform.

Terraform also generates `inventory.ini` file for Ansible for further playbook calls.

## single-vm

Single virtual machine experiments.

Terraform should be installed and following environment variables should be set:

```bash
# AWS credentials.
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="yyy"
export AWS_DEFAULT_REGION="zzz"

# Personal public key for SSH connection (a value).
# To read the key from a default path use following value:
# "$(cat ~/.ssh/id_rsa.pub)"
export TF_VAR_STUDY_ANSIBLE_PUBLIC_KEY="ssh-rsa zzz"

# A path to private SSH key file.
# Default value is "~/.ssh/id_rsa"
export TF_STUDY_ANSIBLE_PRIVATE_KEY_FILE="~/.ssh/id_rsa"

# Set a personal SSH access security rule for the instance.
# To get personal external IP-address dynamically use:
# "$(curl --silent http://ipecho.net/plain)/32"
export TF_VAR_STUDY_ANSIBLE_PERSONAL_SSH_ACCESS_CIDR="xxx.xxx.xxx.xxx/32"
```

A working directory should be `single-vm`

```bash
cd ./single-vm
```

Then setup the environment using Terraform:

* init the working copy project

    ```bash
    terraform init
    ```

* check what Terraform is going to do

    ```bash
    terraform plan
    ```

* and run

    ```bash
    terraform apply
    ```

**DO NOT FORGET** to stop the instances after the work using (to save a AWS budget)

```bash
terraform destroy
```

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
