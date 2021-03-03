#!/bin/bash

# prelink.sh
# ==========
# Manual ssh authorization configuration with a target system

source .env

trap 'handler $?' ERR

handler() {
    # use existance of local key file to check for idempotence
    if [ -f "$LOCAL_KEY_PATH" ]; then
        printf "%b" "${FAIL} ✗ ${NC} prelink step failed\n"
        exit $1
    fi
}

printf "%b" "${OKB}Appending key from default public key path: $PUB_KEY_PATH to $PRELINK_USER@$PRELINK_IP:/.ssh/authorized_keys${NC}"
cat "$PRELINK_KEY_PATH" | ssh "$PRELINK_USER"@"$PRELINK_IP" "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
printf "%b" "${OKG} ✓ ${NC} complete\n"