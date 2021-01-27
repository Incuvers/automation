# Create Incuvers User 
The following set of instructions shows how to create a new super user account and removing the default ubuntu user. The closer to a fresh install the better since its painful to copy over files from the ubuntu user to the new user (like the ssh keys as shown below):

These steps need to be done on the target machine.

```bash
# create new user
sudo adduser incuvers-tp
...
# add new user to sudo group
sudo usermod -aG sudo incuvers-tp
# logout and log back in as incuvers-tp
logout
...
# copy over ssh authorized keys from ubuntu user (if required)
mkdir -p ~/.ssh
sudo cp ../ubuntu/.ssh/authorized_keys ~/.ssh/.
sudo chown incuvers-tp:incuvers-tp ~/.ssh/authorized_keys
# delete old ubuntu user
sudo userdel -r ubuntu
```