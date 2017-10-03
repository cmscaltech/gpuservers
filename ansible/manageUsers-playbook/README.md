As of now we already know what are tasks and handlers and how to use then in ansible. But writing all the yml in to one single file is not the good option .In fact we have roles defined in side playbooks which help us to organise our files.
In side any playbook, create below mentioned directories as I have created in my “manage_users” playbook
```
[root@puppetmaster manage_users]# tree
.
├── roles
│ ├── usercreate
│ │ ├── defaults
│ │ ├── files
│ │ ├── handlers
│ │ ├── meta
│ │ ├── tasks
│ │ │ └── main.yml
│ │ ├── templates
│ │ └── vars
│ └── userdel
│ ├── defaults
│ ├── files
│ ├── handlers
│ ├── meta
│ ├── tasks
│ │ └── main.yml
│ ├── templates
│ └── vars
└── site.yml
```
So “usercreate ” and “userdel ” are the two roles created .Below is the short description regarding each directory of the role.<br>
- If roles/x/tasks/main.yml exists, tasks listed therein will be added to the play
- If roles/x/handlers/main.yml exists, handlers listed therein will be added to the play
- If roles/x/vars/main.yml exists, variables listed therein will be added to the play
- If roles/x/meta/main.yml exists, any role dependencies listed therein will be added to the list of roles (1.3 and later)
- Any copy tasks can reference files in roles/x/files/ without having to path them relatively or absolutely
- Any script tasks can reference scripts in roles/x/files/ without having to path them relatively or absolutely
- Any template tasks can reference files in roles/x/templates/ without having to path them relatively or absolutely
- Any include tasks can reference files in roles/x/tasks/ without having to path them relatively or absolutely

<h6>Creating User_manage playbook</h6>

Here I will be explaining as how to create user_manage playbook with “usercreate” and “userdel” roles each.

- Create a “user_manage”empty playbook directory and create site.yml file inside it.
```
mkdir user_manage
cd user_manage
touch site.yml
```
- Create a “roles” directory inside “user_manage” with “usercreate” and “userdel” directories inside it.
```
mkdir usercreate userdel
```
- Inside each role create below sub-directories
```
cd userdel &amp;&amp; mkdir defaults files handlers meta tasks templates vars
cd ../ usercreate &amp;&amp; mkdir defaults files handlers meta tasks templates vars
```
- Lets build our roles now .For now we will be using only the task directory of our roles in this example and will write main.yml file inside each role.We don’t need other directories for this example but will be utilizing all in our next examples.

- Create main.yml file inside the “usercreate/tasks” with content as shown below.

<a href="https://thinkingmonster.files.wordpress.com/2015/04/role1.png"><img class=" size-full wp-image-432 aligncenter" src="https://thinkingmonster.files.wordpress.com/2015/04/role1.png" alt="role1" width="529" height="198" /></a>
- Create main.yml file inside the “userdel/tasks” with content as shown below.

<a href="https://thinkingmonster.files.wordpress.com/2015/04/role2.png"><img class=" size-full wp-image-433 aligncenter" src="https://thinkingmonster.files.wordpress.com/2015/04/role2.png" alt="role2" width="442" height="87" /></a>

- Once main.yml files are created inside the roles add below data to site.yml file inside “manage_users” playbook

<a href="https://thinkingmonster.files.wordpress.com/2015/04/role3.png"><img class=" size-full wp-image-434 aligncenter" src="https://thinkingmonster.files.wordpress.com/2015/04/role3.png" alt="role3" width="529" height="98" /></a>

<h6>Explaining the concept</h6>
<span style="text-decoration: underline;"><em>site.yml</em></span>

- When creating a user using my play book I will be running my play book with below command
<span style="color: #000080;"><em>ansible-playbook site.yml --extra-vars "username= password= admin=yes action=create_user"</em></span>

Here I am passing all the variables from command line when running site.yml so below code in site.yml assigns the values further to the variable.<br>

```
vars:
 user_password: "{{ password }}"
 user_name: "{{ username }}"
 is_admin: "{{ admin }}"
```
so now “user_password”,”user_name” and “is admin” has the value of input variables.

- In next lines I have called the related roles and have passed these variables to the roles so that they van be used.
```
roles:
{ role: usercreate ,upassword: "{{ user_password }}",uusername: "{{ user_name }}",assigned_role: "{{ is_admin }}", when: action == "create_user" }
{ role: userdel ,uusername: "{{ user_name }}", when: action == "delete_user" }
```
- Here “upasswd”,”uusername” and “assigned_role” are the variable defined inside “createuser” role.Check main.yml file of the role inside tasks.

So this is the way how variables are passed from the command line across the site.yml and to the roles finally.


<h6>Below diagram shows the use of <b>manage-users</b> playbook</h6>
<div align="center"> <img src="https://github.com/thinkingmonster/ansible/blob/master/usermanagement.png" alt="usermanagement"></div> 

<h6>Playbook usages</h6>
<b>Add new admin user</b>
```
ansible-playbook linux_users.yml --extra-vars "username=<username>  password=<password> admin=yes action=create_user remote=<environment logical group|single host>" -u ansible --sudo  -K
```
<b>Delete user</b>
```
ansible-playbook linux_users.yml --extra-vars "username=<username> action=delete_user remote=<environment logical group|single host>" -u ansible --sudo  -K
```
<b>Add non admin user</b>
```
ansible-playbook linux_users.yml --extra-vars "username=<username>  password=<password> admin=no action=create_user remote=<environment logical group|single host>" -u ansible --sudo  -K
```
<b>Add postgresql  user</b>
```
ansible-playbook postgres_users.yml --extra-vars "remote=<environment logical group|single host> loginuser=<User (role) used to authenticate with PostgreSQL> loginpassword=<Password used to authenticate with PostgreSQL> username=<user you want to create> userpassword=<password for user you are going to create> role=SUPERUSER,CREATEDB,CREATEROLE" --user athakur -k --sudo -K
```
