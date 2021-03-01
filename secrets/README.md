# Secrets

Required contents:
| File           | Reason                                                                         |
|----------------|--------------------------------------------------------------------------------|
| pat.key        | Github personal access token for configuring self-hosted action runner servers |

## Generate Personal Access Token
Follow the steps below to generate your github api PAT. Set the access token permissions for the admin:org scope. Your github user must be an administrator/owner of the Incuvers Organization to generate a key with the correct access permissions.

https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

### Authorization Scopes
The required authorization scopes for the token is as follows:
![img](/docs/img/scopes.png)

### Creating the key file
Add the pat.key file to this directory:
```bash
echo PERSONAL_ACCESS_TOKEN > pat.key
```