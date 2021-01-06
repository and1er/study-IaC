output "study_ansible_public_key" {
  description = "A path to SSH public key file"
  value = var.STUDY_ANSIBLE_PUBLIC_KEY
}

output "study_ansible_personal_ssh_access_cidr" {
  description = "For security group rule"
  value = var.STUDY_ANSIBLE_PERSONAL_SSH_ACCESS_CIDR
}

output "latest_ubuntu_focal_ami_id" {
  value = data.aws_ami.latest_ubuntu_focal.id
}

output "latest_ubuntu_focal_ami_name" {
  value = data.aws_ami.latest_ubuntu_focal.name
}

output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "latest_amazon_linux_ami_name" {
  value = data.aws_ami.latest_amazon_linux.name
}

output "ansible_inventory_file_path" {
  value = var.ansible_inventory_file_path
}

output "ansible_inventory_file_content" {
  value = data.template_file.ansible_inventory_content.rendered
}
