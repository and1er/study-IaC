provider "aws" {}

resource "aws_instance" "ubuntu_ansible_01" {
  ami = "ami-0a3a4169ad7cb0d77"
  instance_type = "t3.micro"

  tags = {
    "Name" = "Ubuntu host for Ansible 01"
  }
}
