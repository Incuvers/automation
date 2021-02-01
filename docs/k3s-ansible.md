# k3s and Ansible Setup

Run the build using the -K flag to become sudo:
```bash
ansible-playbook site.yml -i inventory/incuvers-tp/hosts.ini -K
```