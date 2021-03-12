# Incuvers Automation
[![Actions Status](https://github.com/Incuvers/microk3s/workflows/yamllint/badge.svg)](https://github.com/Incuvers/microk3s/actions?query=workflow%3Ayamllint) [![Actions Status](https://github.com/Incuvers/microk3s/workflows/ansible/badge.svg)](https://github.com/Incuvers/microk3s/actions?query=workflow%ansible) [![Actions Status](https://github.com/Incuvers/microk3s/workflows/shellcheck/badge.svg)](https://github.com/Incuvers/microk3s/actions?query=workflow%3Ashellcheck)

![img](/docs/img/Incuvers-black.png)

Modified: 2021-03

- [Incuvers Automation](#incuvers-automation)
  - [Preface](#preface)
  - [TuringPi Configuration](#turingpi-configuration)
  - [Deployments](#deployments)
    - [Setup](#setup)
    - [Server Automation Configuration](#server-automation-configuration)

## Preface
This repository hosts all the automation and management services for Incuvers' servers. This repository hosts the ansible automation for building and destroying continous deployment pipeline stages for the [Incuvers:monitor](https://github.com/Incuvers/monitor) repository. In the future it will also be expanded to include virtual incubator servers and running R&D cluster computing applications.

## TuringPi Configuration
Follow the TuringPi configuration guide [here](/docs/turingpi.md)

## Deployments
This section contains the instructions for deploying and destroying servers across any number of machines.

### Setup
Install `ansible` using preferred package manager:
```bash
brew install ansible
```
```bash
python3 -m pip install ansible
```
```bash
sudo apt update -y
sudo apt install ansible
```

### Server Automation Configuration
Follow the server specific instructions for automating server deployment and teardown:

<details>
  <summary><b>Build Server</b></summary>
  <h3>Quickstart</h3>
  <p>
  </p>
  <h3>Recommended Hardware</h3>
  <p>
  </p>
</details>

<details>
  <summary><b>Staging Client</b></summary>
  <h3>Quickstart</h3>
  <p>
  </p>
  <h3>Recommended Hardware</h3>
  <p>
  </p>
</details>

<details>
  <summary><b>Deployment Server</b></summary>
  <h3>Quickstart</h3>
  <p>
  </p>
  <h3>Recommended Hardware</h3>
  <p>
  </p>
</details>