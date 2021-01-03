
output "study_ansible_public_key" {
  description = "A path to SSH public key file"
  value = var.STUDY_ANSIBLE_PUBLIC_KEY
}

output "instance_ipv4_address" {
  description = "An IPv4 address of created instance"
  value = aws_instance.ubuntu_ansible_sandbox.public_ip
}
