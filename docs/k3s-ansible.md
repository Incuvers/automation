# k3s and Ansible Setup

Run the build using the -K flag to become sudo:
```bash
ansible-playbook site.yml -i inventory/incuvers-tp/hosts.ini -K
```

Ping all machines by group `node` using ansible `ping` module:
```bash
ansible -i inventory/incuvers-tp/hosts.ini node -m ping -u incuvers-tp
```

Alternatively we can specify the inventory file default in `ansible.cfg`.

### Ad-hoc Commands
Ah-hoc, meaning when necessary, commands are command strings that can be simultaneously executed on single, or groups of servers:

Shutdown all nodes:
```bash
ansible -all -i inventory/incuvers-tp/hosts.ini -a "shutdown now" -b
```

The `-f` flag specifies the number of fork commands to run in parallel. A fork of 1 would be equivalent of running each job on each system sequentially. Alternatively any other postive integer would create that number of parrallel job builds on the servers. 
```bash
ansible cluster -a "hostname" -f 1
```

Set an ad-hoc command to run in the background on the server side:
```bash
ansible cluster -b -B 3600 -P 0 -a "apt -y update"
```
`-B` specifies the time in seconds that the job is allowed to run for and -P is equivalent to nohup which pipes the logs of the command to a file. To access that file use the `async_status` module and pass the job-id for that job:
```bash
ansible cluster -b -m async_status -a "jid=<ansible-job-id>"
```

For running ad-hoc commands that use linux pipes use the shell module:
```bash
ansible cluster -b -m shell -a "tail -f /var/log/syslog | grep systemd | wc -l"
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