# SSH Configuration

SSH to the master node is only enabled for authorized keys. Password access through ssh is disabled. Below I describe this configuration process following this excellent article:
https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-1804

## Hostname configuration
1. Set local hostname on node
    ```bash
    hostnamectl set-hostname <hostname>
    ```
2. Install `avahi-utils` and set outbound hostname to local hostname:
    ```bash
    sudo apt install -y avahi-utils
    ...
    avahi-set-host-name <hostname>
    ```

## First-time Node SSH Configuration
NOTE: if your local machine does not have an ssh key you will not be able to run this target!. Contact christian@incuvers.com for assistance.

1. Validate you can ssh into the node and exit the session:
    ```bash
    ssh ubuntu@<hostname>.local
    ...
    ubuntu@<hostname>:~$ exit
    ```
2. Run the `key-auth` make target from repo root:
    ```bash
    make key-auth
    ```
3. Test ssh connection without password:
    ```bash
    ssh ubuntu@<hostname>
    ```
4. If all is well the last step is to disable ssh password authentication:
    ```bash
    sudo vi /etc/ssh/sshd_config
    ...
    PasswordAuthentication no
    ...
    ```
5. Restart ssh server
    ```bash
    sudo systemctl restart ssh
    ```