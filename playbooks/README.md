# Ansible Playbooks

Modified: 2021-02

## Snap Continous Deployment
The continous deployment configuration playbook sets up all nodes within the `cd` group for continous deployment on the Incuvers:monitor repistory. Preconfigure nodes to the `cd` group using the [hosts.ini](/inventory/hosts.ini) before executing the playbook

Below are the steps to set up the continous deployment configuration playbook:
1. Add a new [Add New Runner](https://github.com/Incuvers/monitor/settings/actions/add-new-runner) for Incuvers:monitor
2. Set the operating system to `Linux` and the architecture to `ARM64`
3. Copy the token in the configuration line and replace the `token` in [cd-vars.yaml](/playbooks/cd-vars.yaml)
    ```bash
    ./config.sh --url https://github.com/Incuvers/monitor --token COPY_THIS_TOKEN
    ```
4. Run the `make cd-config` target from the repository root to kick off the playbook.