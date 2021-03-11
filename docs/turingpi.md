# TuringPi Configuration

![img](/docs/img/Incuvers-black.png)
Modified: 2021-03

- [TuringPi Configuration](#turingpi-configuration)
  - [Preface](#preface)
  - [Quickstart](#quickstart)
  - [Flash Compute Modules](#flash-compute-modules)
  - [User Management](#user-management)
  - [Accessing the Server](#accessing-the-server)

## Preface
Some of the server jobs are hosted on a TuringPi V1 board with 7 RasberryPi 3B+ Compute Modules (RPi CM 3B+) with 32GB of eMMC storage and 1GB of RAM. Collectively the nodes yield a server with the following specification:

| Category  |Quantity|
|-----------|--------|
| CPU Cores | 28     |
| RAM       | 7 GiB  |
| Storage   | 224 GB |
| Network   | 1 Gbps |

## Quickstart
Clone and run setup to generate build artefacts:
```bash
git clone --recurse-submodules https://github.com/Incuvers/microk8s.git
...
make setup
```
This will create a `build` directory for build artefacts. To view available make targets:
```bash
make
```
Configure yourself as the system administrator for each node (allow ssh access):
```bash
make ssh-auth
```

## Flash Compute Modules
This server is designed to work with Ubuntu Server 20.04.1 LTS 64 bit images for the RPi 3. Follow the instructions below to begin flashing the compute modules:
1. Set the first jumper closest to the micro-usb slave programmer port so that it is on the pin with the small triangle indicator. This sets the pinstate to eMMC flash mode. 
2. Connect micro-usb to your local machine
3. Insert eMMC compute module into the master SO-DIMM slot
4. Power TuringPi using 12V VDC in or mini-ITX power cable
5. Run `make flash` to completion
6. Power off the motherboard
7. Repeat from step 3 for all compute modules

## User Management
Each node on the server has a customized `incuvers-tp` user which is part of the `sudo` user group. This is done after each node is flashed but before the server nodes have been configured. There is no automation for this process so the admin must ssh into each node and setup the users. Steps for this process are outlined in the [User Management](/docs/users.md) document.

## Accessing the Server
Password login is disabled through ssh connections for security purposes. In order to access the server you must copy your local machines `id_rsa.pub` to the set of authorized keys on the desired access nodes. This is automated in the setup process (`make ssh-auth` target) using the setup users' RSA public key. Therefore whoever sets up the server becomes the system administrator. If the server is already setup and you require access contact christian@incuvers.com (current sys admin) for assistance.

Using ssh and adhoc shell scripts to manage server nodes is strongly discouraged. For server maintenance and configuration we use the cluster management tool *Ansible*
