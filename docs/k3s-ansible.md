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