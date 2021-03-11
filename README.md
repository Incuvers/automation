# Incuvers Automation
[![Actions Status](https://github.com/Incuvers/microk3s/workflows/yamllint/badge.svg)](https://github.com/Incuvers/microk3s/actions?query=workflow%3Ayamllint) [![Actions Status](https://github.com/Incuvers/microk3s/workflows/ansible/badge.svg)](https://github.com/Incuvers/microk3s/actions?query=workflow%ansible) [![Actions Status](https://github.com/Incuvers/microk3s/workflows/shellcheck/badge.svg)](https://github.com/Incuvers/microk3s/actions?query=workflow%3Ashellcheck)

![img](/docs/img/Incuvers-black.png)

Modified: 2021-03

- [Incuvers Automation](#incuvers-automation)
  - [Preface](#preface)
  - [TuringPi Configuration](#turingpi-configuration)

## Preface
This repository hosts all the automation and management services for the Incuvers build and deployment servers. Some of the servers are hosted on a TuringPi V1 board hosting 7 RasberryPi 3B+ Compute Modules (RPi CM 3B+) with 32GB of eMMC storage and 1GB of RAM. Collectively the nodes yield a server with the following specification:

| Category  |Quantity|
|-----------|--------|
| CPU Cores | 28     |
| RAM       | 7 GiB  |
| Storage   | 224 GB |
| Network   | 1 Gbps |

Currently the server hosts some of the continous integration and deployment jobs for the [Incuvers:monitor](https://github.com/Incuvers/monitor) repository. In the future it will also be expanded to include virtual incubator servers and running R&D cluster computing applications.

## TuringPi Configuration

Follow the TuringPi configuration guide [here](/docs/)