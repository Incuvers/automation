#!/bin/bash

source .env

printf "%b" "${OKB}Executing $1 playbook${NC}\n"
ansible-playbook playbooks/$1 -K --extra-vars "pa_token=${PA_TOKEN}"\
	&& printf "%b" "${OKG} ✓ ${NC} complete\n" || \
	printf "%b" "${FAIL} ✗ ${NC} playbook execution failed.\n"