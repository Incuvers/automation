# Secrets

Required contents:
| File           | Reason                                                                         |
|----------------|--------------------------------------------------------------------------------|
| pat.key        | Github personal access token for configuring self-hosted action runner servers |
| access_key.key | AWS S3 bucket access key                                                       |
| access_id.key  | AWS S3 bucket access id                                                        |

## Generate Personal Access Token
Follow the steps below to generate your github api PAT. Set the access token permissions for the admin:org scope. Your github user must be an administrator/owner of the Incuvers Organization to generate a key with the correct access permissions.

https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

### Creating the key file
Add the pat.key file to this directory:
```bash
echo PERSONAL_ACCESS_TOKEN > pat.key
```

## AWS S3 Access Tokens
We use AWS S3 to store completed snap build files so that any device can pull the snap file and install it. We create a bucket for this file and store the access tokens here.