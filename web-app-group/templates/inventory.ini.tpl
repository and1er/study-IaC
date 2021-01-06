[web_hosts]
web-1 ansible_host=${web_host}

[web_hosts:vars]
ansible_ssh_user = ${amazon_linux_ssh_user}
ansible_python_interpreter = ${amazon_linux_python_interpreter}

[app_hosts]
app-1 ansible_host=${app1_host}
app-2 ansible_host=${app2_host}

[app_hosts:vars]
ansible_ssh_user = ${ubuntu_ssh_user}
ansible_python_interpreter = ${ubuntu_python_interpreter}

[db_hosts]
db-1 ansible_host=${db_host}

[db_hosts:vars]
ansible_ssh_user = ${ubuntu_ssh_user}
ansible_python_interpreter = ${ubuntu_python_interpreter}

[vms:children]
web_hosts
app_hosts
db_hosts

[vms:vars]
ansible_ssh_private_key_file = ${ssh_private_key_file}
