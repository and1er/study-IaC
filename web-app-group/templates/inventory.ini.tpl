[web_hosts]
web-1 ansible_host=${web_host}

[app_hosts]
app-1 ansible_host=${app1_host}
app-2 ansible_host=${app2_host}

[db_hosts]
db-1 ansible_host=${db_host}

[vms:children]
web_hosts
app_hosts
db_hosts

[vms:vars]
ansible_ssh_user = ${ssh_user}
ansible_ssh_private_key_file = ${ssh_private_key_file}
ansible_python_interpreter = ${python_interpreter}
