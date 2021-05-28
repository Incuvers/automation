# Ansible Vault

To run ansible vault you will need the `vault.key` master key file in the `secrets/` directory. Contact christian@incuvers.com or david@incuvers.com for assistance.

To access ansible-vault you need to be in the root of the repository.

```bash
ansible-vault encrypt path/to/file
Encryption successful
```

```bash
ansible-vault decrypt path/to/file
Decryption successful
```

Be very careful not to decrypt and push any secrets! always check your staging changes.