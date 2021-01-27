# Incuvers MicroK8s Cluster Control
[![Actions Status](https://github.com/Incuvers/microk8s/workflows/yamllint/badge.svg)](https://github.com/Incuvers/microk8s/actions?query=workflow%3Ayamllint) [![Actions Status](https://github.com/Incuvers/microk8s/workflows/shellcheck/badge.svg)](https://github.com/Incuvers/microk8s/actions?query=workflow%3Ashellcheck)

![img](/docs/img/Incuvers-black.png)

Modified: 2020-12

- [Incuvers MicroK8s Cluster Control](#incuvers-microk8s-cluster-control)
  - [Automating Cluster Setup](#automating-cluster-setup)
  - [Quickstart](#quickstart)

## Automating Cluster Setup
1. Set the first jumper closest to the micro-usb slave programmer port so that it is on the pin with the small triangle indicator. This sets the pinstate to eMMC flash mode. 
2. Connect micro-usb to your local machine
3. Insert eMMC compute module into the master SO-DIMM slot
4. Power TuringPi using 12V VDC in or mini-ITX power cable

## Quickstart
Clone and run setup to generate build artefacts:
```bash
git clone --recurse-submodules https://github.com/Incuvers/microk8s.git
```
```bash
make setup
```
This will create a `build` directory build artefacts. To remove the build directory after flashing nodes and perform other cleanup:
```bash
make clean
```
Prepare TuringPi board for slave port flashing as per [instructions](#turingpi-setup) then run following the prompts:
```bash
make flash
```

## Accessing the Server
In order to access the server you must copy your local machines `id_rsa.pub` to the set of authorized keys on the master node. Contact christian@incuvers.com for assistance. Password login is disabled through ssh connections for security purposes.

Accessing the master node on LAN is done by:
```
ssh incuvers-tp@master.local
```