<b>ping all GPUs (but not ibanks itself)</b>

ansible-playbook ping.yml


<b>for user creation, start from an example and make changes</b>

https://github.com/thinkingmonster/ansible/tree/master/manageUsers-playbook

<b>example creating a user on all servers (including ibanks)</b>

ansible-playbook ./manageUsers-playbook/linux_users.yml --extra-vars "username=dk31 password=dk31 admin=no ugroups=gpu-users home=/nfshome/dk31 action=gpu_user remote=all" -u root

<b>example deleting a user on all servers (including ibanks)</b>

ansible-playbook ./manageUsers-playbook/linux_users.yml --extra-vars "username=dk31 action=delete_user remote=all" -u root
