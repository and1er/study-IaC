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
variable "ansible_inventory_ssh_user" {
  type = string
  default = "ubuntu"
}

variable "ansible_inventory_python_interpreter" {
  type = string
  default = "/usr/bin/python3"
}
