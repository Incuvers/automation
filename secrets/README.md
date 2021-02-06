# Github API Personal Access Token

Required contents:
 - pat.key

## Generate Personal Access Token
Follow the steps below to generate your github api PAT. Set the access token permissions for the admin:org scope. Your github user must be an administrator/owner of the Incuvers Organization to generate a key with the correct access permissions.

https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

## Create the key file
```bash
echo pat_key=PERSONAL_ACCESS_TOKEN > pat.key
```

