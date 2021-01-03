study-ansible
================

My Ansible study on AWS instances provisioned by Terraform.

Run Terraform
----------------

Terraform should be installed and following environment variables should be set:

```bash
# AWS credentials.
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="yyy"
export AWS_DEFAULT_REGION="zzz"

# Personal public key for SSH connection.
export TF_VAR_STUDY_ANSIBLE_PUBLIC_KEY="ssh-rsa zzz"
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

To stop the instances in the end use

```bash
terraform destroy
```
