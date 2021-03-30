# Environment variables (without 'TF_' prefix).
variable "STUDY_ANSIBLE_PUBLIC_KEY" {
  type = string
}
variable "STUDY_ANSIBLE_PRIVATE_KEY_FILE" {
  type = string
  default = "~/.ssh/id_rsa"
}
variable "STUDY_ANSIBLE_PERSONAL_SSH_ACCESS_CIDR" {
  type = string
}

# Local variables.
variable "ansible_inventory_file_path" {
  type = string
  default = "./inventory.ini"
}
variable "ansible_inventory_ubuntu_ssh_user" {
  type = string
  default = "ubuntu"
}
variable "ansible_inventory_amazon_linux_ssh_user" {
  type = string
  default = "ec2-user"
}

variable "ansible_inventory_ubuntu_python_interpreter" {
  type = string
  default = "/usr/bin/python3"
}

variable "ansible_inventory_amazon_linux_python_interpreter" {
  type = string
  default = "/usr/bin/python"
}
