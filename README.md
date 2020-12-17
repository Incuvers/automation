# Automation for TuringPi K3S Blade Cluster using HypriotOS
[![Actions Status](https://github.com/Incuvers/microk8s/workflows/yamllint/badge.svg)](https://github.com/Incuvers/microk8s/actions?query=workflow%3Ayamllint) [![Actions Status](https://github.com/Incuvers/microk8s/workflows/shellcheck/badge.svg)](https://github.com/Incuvers/microk8s/actions?query=workflow%3Ashellcheck)

![img](docs/img/tp.jpeg) ![img](docs/img/logo_tr.png)![img](docs/img/k3s.png) 

Modified: 2020-10

## Navigation
- [Automation for TuringPi K3S Blade Cluster using HypriotOS](#automation-for-turingpi-k3s-blade-cluster-using-hypriotos)
  - [Navigation](#navigation)
  - [Automating Cluster Setup](#automating-cluster-setup)
  - [TuringPi Setup](#turingpi-setup)
  - [Quickstart](#quickstart)
  - [License](#license)

## Automating Cluster Setup

Downloading dependancies, flashing compute modules, setting up custom node configs are all tedious and time consuming processes. This repository leverages automation for faster and more consistent setup results for turingpi 

## TuringPi Setup
1. Set the first jumper closest to the micro-usb slave programmer port so that it is on the pin with the small triangle indicator. This sets the pinstate to eMMC flash mode. 
2. Connect micro-usb to your local machine
3. Insert eMMC compute module into the master SO-DIMM slot
4. Power TuringPi using 12V VDC in or mini-ITX power cable

## Quickstart
Clone and run setup to generate build artefacts:
```bash
git clone --recurse-submodules https://github.com/cSDes1gn/blade-k3s
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

## License
[GNU General Public License v3.0](#LICENSE)


