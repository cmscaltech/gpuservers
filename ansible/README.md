# ping all GPUs (but not ibanks itself)
ansible-playbook ping.yml


# for user creation, use the example here: https://github.com/thinkingmonster/ansible/tree/master/manageUsers-playbook

# example creating a user on all servers (including ibanks)
ansible-playbook ./manageUsers-playbook/linux_users.yml --extra-vars "username=dk31 password=dk31 admin=no ugroups=gpu-users home=/nfshome/dk31 action=gpu_user remote=all" -u root

# example deleting a user on all servers (including ibanks
ansible-playbook ./manageUsers-playbook/linux_users.yml --extra-vars "username=dk31 action=delete_user remote=all" -u root
