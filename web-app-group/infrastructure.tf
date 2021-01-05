provider "aws" {}

# --- SSH access key ---
resource "aws_key_pair" "ssh_access_key" {
  key_name = "vm-ssh-access-key"
  public_key = var.STUDY_ANSIBLE_PUBLIC_KEY
}

# --- Security groups ---
# TODO: Separate security groups for each host role.
resource "aws_security_group" "webserver_group" {
  name = "Webserver security group"
  description = "Basic security rules for webservers."

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      description = "Incoming webserver tcp connections."
      from_port = ingress.value
      to_port = ingress.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "Incoming SSH connections"
    cidr_blocks = [var.STUDY_ANSIBLE_PERSONAL_SSH_ACCESS_CIDR]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  egress {
    description = "Allow all output traffic"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}

# --- VPC ---
# TODO: Create a VPC.

# --- Instances ---
# Lookup for latest Ubuntu 20.04 OS image for any region.
# Tested on "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20201210"
data "aws_ami" "latest_ubuntu_focal" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}
# Launch the instances.
resource "aws_instance" "web_ansible_sandbox_host" {
  ami = data.aws_ami.latest_ubuntu_focal.id
  instance_type = "t3.micro"
  key_name = "vm-ssh-access-key"
  vpc_security_group_ids = [
    aws_security_group.webserver_group.id
  ]

  tags = {
    "Name" = "Web Ansible sandbox host"
    "Role" = "web-server"
  }
}

resource "aws_instance" "app_ansible_sandbox_host" {
  ami = data.aws_ami.latest_ubuntu_focal.id
  instance_type = "t3.micro"
  key_name = "vm-ssh-access-key"
  vpc_security_group_ids = [
    aws_security_group.webserver_group.id
  ]
  count = 2
  tags = {
    "Name" = "Application Ansible sandbox host"
    "Role" = "app-server"
  }
}

resource "aws_instance" "db_ansible_sandbox_host" {
  ami = data.aws_ami.latest_ubuntu_focal.id
  instance_type = "t3.micro"
  key_name = "vm-ssh-access-key"
  vpc_security_group_ids = [
    aws_security_group.webserver_group.id
  ]
  tags = {
    "Name" = "Database Ansible sandbox host"
    "Role" = "db-server"
  }
}

# Generate Ansible inventory file.
data "template_file" "ansible_inventory_content" {
  template = file("./templates/inventory.ini.tpl")
  vars = {
    # Hosts.
    web_host = aws_instance.web_ansible_sandbox_host.public_ip
    # TODO: Process multiple instances dynamically.
    app1_host = aws_instance.app_ansible_sandbox_host[0].public_ip
    app2_host = aws_instance.app_ansible_sandbox_host[1].public_ip
    db_host = aws_instance.db_ansible_sandbox_host.public_ip
    # Parameters
    ssh_user = var.ansible_inventory_ssh_user
    ssh_private_key_file = var.STUDY_ANSIBLE_PRIVATE_KEY_FILE
    python_interpreter = var.ansible_inventory_python_interpreter
  }
}
resource "local_file" "ansible_inventory_file" {
  content = data.template_file.ansible_inventory_content.rendered
  filename = var.ansible_inventory_file_path
}
