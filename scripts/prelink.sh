#!/bin/bash

# prelink.sh
# ==========
# Manual ssh authorization configuration with a target system

source scripts/.env

# prelink config
KEY_PATH="$HOME/.ssh/id_rsa.pub"
PRELINK_USER="ubuntu"
PRELINK_IP=192.168.2.68
PRELINK_KEY=$(< "$KEY_PATH")

trap 'handler $?' ERR

handler() {
    printf "%b" "${FAIL} ✗ ${NC} prelink step failed\n"
    exit "$1"
}

printf "%b" "${OKB}Appending local public key to $PRELINK_USER@$PRELINK_IP:/.ssh/authorized_keys${NC}\n"
ssh "$PRELINK_USER"@"$PRELINK_IP" "mkdir -p ~/.ssh && echo $PRELINK_KEY >> ~/.ssh/authorized_keys"
printf "%b" "${OKG} ✓ ${NC} complete\n"