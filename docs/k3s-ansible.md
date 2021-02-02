# k3s and Ansible Setup

Run the build using the -K flag to become sudo:
```bash
ansible-playbook site.yml -i inventory/incuvers-tp/hosts.ini -K
```

Shutdown all nodes:
```bash
ansible -all -i inventory/incuvers-tp/hosts.ini -a "shutdown now" -b
```

Ping all machines by group `node` using ansible `ping` module:
```bash
ansible -i inventory/incuvers-tp/hosts.ini node -m ping -u incuvers-tp
```

Alternatively we can specify the inventory file default in `ansible.cfg`.

The `-f` flag specifies the number of fork commands to run in parallel. A fork of 1 would be equivalent of running each job on each system sequentially. Alternatively any other postive integer would create that number of parrallel job builds on the servers. 
```bash
ansible cluster -a "hostname" -f 1
```

### Setup module
Obtain information on a group of servers
```bash
ansible master -m setup
```

### Package management
```bash
ansible cluster -b -m apt -a "name=net-tools state=present" -K
```