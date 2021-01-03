provider "aws" {}

# SSH access key.
resource "aws_key_pair" "ssh_access_key" {
  key_name = "and1er-ssh-access-key"
  public_key = var.STUDY_ANSIBLE_PUBLIC_KEY
}

# Security groups.
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

# Instances.
resource "aws_instance" "ubuntu_ansible_sandbox" {
  ami = "ami-0a3a4169ad7cb0d77"
  instance_type = "t3.micro"
  key_name = "and1er-ssh-access-key"
  vpc_security_group_ids = [
    aws_security_group.webserver_group.id
  ]

  tags = {
    "Name" = "Single Ansible sandbox host"
  }
}

# Generate Ansible inventory file.
data "template_file" "ansible_inventory_content" {
  template = file("./templates/inventory.ini.tpl")
  vars = {
    sandbox_host = aws_instance.ubuntu_ansible_sandbox.public_ip
    ssh_user = var.ansible_inventory_ssh_user
    ssh_private_key_file = var.STUDY_ANSIBLE_PRIVATE_KEY_FILE
    python_interpreter = var.ansible_inventory_python_interpreter
  }
}
resource "local_file" "ansible_inventory_file" {
  content = data.template_file.ansible_inventory_content.rendered
  filename = var.ansible_inventory_file_path
}
