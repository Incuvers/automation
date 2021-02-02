#!/bin/bash

# Load the contents of the AWS ACCESS KEY and KEY ID to the environment variables
# export AWS_ACCESS_KEY_ID=$(cat /app/docker/secrets/AWS_ACCESS_KEY_ID.txt | tr -d '\n' | tr -d '\r');
# export AWS_SECRET_ACCESS_KEY=$(cat /app/docker/secrets/AWS_SECRET_ACCESS_KEY.txt | tr -d '\n' | tr -d '\r');

# Download the cert files if they are missing
# f1="/app/assets/certs/serial_certs_dev/private.pem.key";
# f2="/app/assets/certs/serial_certs_dev/certificate.pem.crt";
# if [[ ! -f "$f1" || ! -f "$f2" ]]; then
#     python3 /app/create_cert_files.py dev;
# fi

# Start the sls wsgi server in the foreground
# /sbin/init;
snapcraft;
