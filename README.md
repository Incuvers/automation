# Incuvers MicroK3s Cluster
[![Actions Status](https://github.com/Incuvers/microk8s/workflows/yamllint/badge.svg)](https://github.com/Incuvers/microk8s/actions?query=workflow%3Ayamllint) [![Actions Status](https://github.com/Incuvers/microk8s/workflows/shellcheck/badge.svg)](https://github.com/Incuvers/microk8s/actions?query=workflow%3Ashellcheck)

![img](/docs/img/Incuvers-black.png)

Modified: 2021-02

- [Incuvers MicroK3s Cluster](#incuvers-microk3s-cluster)
  - [Preface](#preface)
  - [Flashing Compute Modules](#flash-compute-modules)
  - [Automating Cluster Setup](#automating-cluster-setup)
  - [Quickstart](#quickstart)

## Preface
This repository hosts all the automation and management services for the Incuvers build and deployment server. This server is a TuringPi V1 board hosting 7 RasberryPi 3B+ Compute Modules (RPi CM 3B+) with 32GB of eMMC storage and 1GB of RAM. Collectively the nodes yield a server with the following specification:

| TuringPi V1    ||
|-----------|--------|
| CPU Cores | 28     |
| RAM       | 7 GiB  |
| Storage   | 224 GB |
| Network   | 1 Gbps |

The server hosts the continous integration and deployment jobs for the [Incuvers:monitor](https://github.com/Incuvers/monitor) repository. In the future it will also be expanded to include virtual incubator servers and running cluster computing applications.

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
## Flash Compute Modules
This server is designed to work with Ubuntu Server 20.04.1 LTS 64 bit images for the RPi 3. Follow the instructions below to begin flashing the compute modules:
1. Set the first jumper closest to the micro-usb slave programmer port so that it is on the pin with the small triangle indicator. This sets the pinstate to eMMC flash mode. 
2. Connect micro-usb to your local machine
3. Insert eMMC compute module into the master SO-DIMM slot
4. Power TuringPi using 12V VDC in or mini-ITX power cable
5. Execute:
   ```bash
   make flash
   ```
6. When complete turn off the Turingpi
7. Repeat from step 3 for all compute modules

## Accessing the Server
In order to access the server you must copy your local machines `id_rsa.pub` to the set of authorized keys on each node. Contact christian@incuvers.com for assistance. Password login is disabled through ssh connections for security purposes.

Accessing the master node on LAN is done by:
```bash
ssh incuvers-tp@master.local
```

Subsequent slave nodes are accessed (X: [1-6]):
```bash
ssh incuvers-tp@slaveX.local
...
```
