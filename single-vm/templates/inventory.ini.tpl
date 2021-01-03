[sandbox_hosts]
${sandbox_host}

[all:vars]
ansible_ssh_user = ${ssh_user}
ansible_ssh_private_key_file = ${ssh_private_key_file}
ansible_python_interpreter = ${python_interpreter}
