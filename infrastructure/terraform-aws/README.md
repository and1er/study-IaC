Terraform AWS
=========================

My IaC study on AWS instances provisioned by Terraform.

The infrastructure is created in AWS EC2 cloud service using Terraform.

Terraform also generates `inventory.ini` file and deploys public SSH key for Ansible for further playbook calls.

Requirements
-------------------

To setup the environment and run playbooks (the actual versions I used are listed below)


* get AWS user access key pair from [AWS account](https://aws.amazon.com/), [IAM service](https://console.aws.amazon.com/iam/home);
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