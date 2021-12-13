# Incuvers Automation
[![Actions Status](https://github.com/Incuvers/microk3s/workflows/yamllint/badge.svg)](https://github.com/Incuvers/microk3s/actions?query=workflow%3Ayamllint) [![Actions Status](https://github.com/Incuvers/microk3s/workflows/ansible/badge.svg)](https://github.com/Incuvers/microk3s/actions?query=workflow%ansible) [![Actions Status](https://github.com/Incuvers/microk3s/workflows/shellcheck/badge.svg)](https://github.com/Incuvers/microk3s/actions?query=workflow%3Ashellcheck)

![img](/docs/img/Incuvers-black.png)

Modified: 2021-04

- [Incuvers Automation](#incuvers-automation)
  - [Preface](#preface)
  - [TuringPi Configuration](#turingpi-configuration)
  - [Deployments Setup](#deployments-setup)
    - [Tools](#tools)
    - [Environment and Inventory](#environment-and-inventory)
    - [Ansible Vault](#ansible-vault)
    - [Server Specific Configuration](#server-specific-configuration)

## Preface
This repository hosts all the automation and management services for Incuvers servers. This repository hosts the ansible automation for managing the continous deployment and continous integration pipelines for the [Incuvers/monitor](https://github.com/Incuvers/monitor) repository. In the future it will also be expanded to include virtual incubator servers and running R&D cluster computing applications.

## TuringPi Configuration
Follow the TuringPi configuration guide [here](/docs/turingpi.md)

## Deployments Setup
This section contains the instructions for deploying and destroying servers across any number of machines.

### Tools
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

### Environment and Inventory
Create a copy of the [`example.inventory.yaml`](/inventory/example.inventory.yaml) files and remove the `example.` prefix from it. This file describes your host configuration for your deployment.

Once done, fire off the playbook using its path. For example, the `iris-stage` playbook:
```bash
ansible-playbook playbooks/iris-stage.yaml
```
### Ansible Vault
Some of the automation deployments, such as github actions servers require secrets. These secrets are encrypted with AES using ansible vault and are version controlled. Ansible vault will decrypt the neccessary secrets for a given action at playbook runtime provided you have the ansible vault password file. This means that instead of syncing serveral different key files with everyone only the ansible vault password file is required to get access to all the key files. Contact christian@incuvers.com for the vault key file.

### Server Specific Configuration
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