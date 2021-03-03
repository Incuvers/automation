#!/bin/bash

# prelink.sh
# ==========
# Manual ssh authorization configuration with a target system

source .env

trap 'handler $?' ERR

handler() {
    printf "%b" "${FAIL} ✗ ${NC} prelink step failed\n"
    exit "$1"
}

printf "%b" "${OKB}Appending local public key to $PRELINK_USER@$PRELINK_IP:/.ssh/authorized_keys${NC}\n"
ssh "$PRELINK_USER"@"$PRELINK_IP" "mkdir -p ~/.ssh && echo $PRELINK_KEY >> ~/.ssh/authorized_keys"
printf "%b" "${OKG} ✓ ${NC} complete\n"