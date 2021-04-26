# Serial Certifications
This directory is the local storage for credentials identifying this device when connecting to Incuvers webservices. The identity issuer generates this folder and places it here in `monitor/daemon/ident/`. This directory name and contents must not be modified by users.

These certs will be stored in `/home/ubuntu/.secrets/` and artifically inserted into `$SNAP_COMMON` before each snap is installed. Note that this server runs as a daemon process which is run as root. Root resolves `$HOME` to `/root` and the ubuntu user resolved `$HOME` to `/home/ubuntu`. This should be taken into consideration regarding path resolution and server configuration. 

## Expected Contents
| System Permissions          | File name           |
|-----------------------------|---------------------|
| -rw-r--r-- 1 ubuntu ubuntu  | cert_arn.txt        |
| -rw-r--r-- 1 ubuntu ubuntu  | cert_id.txt         |
| -rw-r--r-- 1 ubuntu ubuntu  | certificate.pem.crt |
| -rw-r--r-- 1 ubuntu ubuntu  | customer_id.txt     |
| -rw-r--r-- 1 ubuntu ubuntu  | id.txt              |
| -rw-r--r-- 1 ubuntu ubuntu  | private.pem.key     |
| -rw-r--r-- 1 ubuntu ubuntu  | public.pem.key      |
| -rw-r--r-- 1 ubuntu ubuntu  | uuid.txt            |
| -rw-r--r-- 1 ubuntu ubuntu  | hostname.txt        |
| -rw-r--r-- 1 ubuntu ubuntu  | AmazonRootCA1.txt   |