#!/bin/bash

# prelink.sh
# ==========
# Manual ssh authorization configuration with a target system

source scripts/.env

PRELINK_USER=""
PRELINK_IP=""

while getopts ":hu:a:" opt; do
    case "$opt" in
        h )
            echo "Usage:"
            echo "      prelink.sh -h                       Display this message"
            echo "      prelink -u ubuntu -a 10.1.52.98     Setup ssh link for user ubuntu on host 10.1.52.98"
            exit 0;
            ;;
        u )
            PRELINK_USER="$OPTARG"
            ;;
        a )
            PRELINK_IP="$OPTARG"
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            exit 1;
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            exit 1;
            ;;
    esac
done

shift $((OPTIND -1))

if [ -z "$PRELINK_USER" ] || [ -z "$PRELINK_IP" ]; then
        echo 'Missing -u or -a' >&2
        exit 1
fi

# prelink config
KEY_PATH="$HOME/.ssh/id_rsa.pub"
PRELINK_KEY=$(< "$KEY_PATH")
trap 'handler $?' ERR

handler() {
    printf "%b" "${FAIL} ✗ ${NC} prelink step failed\n"
    exit "$1"
}

printf "%b" "${OKB}Appending local public key to $PRELINK_USER@$PRELINK_IP:/.ssh/authorized_keys${NC}\n"
ssh "$PRELINK_USER"@"$PRELINK_IP" "mkdir -p ~/.ssh && echo $PRELINK_KEY >> ~/.ssh/authorized_keys"
printf "%b" "${OKG} ✓ ${NC} complete\n"