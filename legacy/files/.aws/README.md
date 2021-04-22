# AWS Secrets

Modified: 2021-02

This folder and its contents are required by the AWS python SDK (`boto3`) to be in the home directory. Note that this server runs as a daemon process which is run as root. Root resolves `$HOME` to `/root` and the ubuntu user resolved `$HOME` to `/home/ubuntu`. This should be taken into consideration regarding path resolution and server configuration. 

## Secrets
`.aws/credentials` file stores the access key id and secret access key for the an IAM user with policy restrictions that are equal to or more permissive than the `snap-ci` user.

## Config
`.aws/config` file stores the region label for the aws service.