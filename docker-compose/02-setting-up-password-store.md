Now let's configure password-store.  It configured using the [password-store Documentation Environment Variables](https://git.zx2c4.com/password-store/about/):

```
$PASSWORD_STORE_DIR
```

Initialized the directory:

```
mkdir --parent --verbose $PASSWORD_STORE_DIR
```

Initialize the store with the GPG key

```
pass init crypto.user@server.com
```

### Generate user password and add it to store

[pwgen man page](https://linux.die.net/man/1/pwgen), [password-store](https://www.passwordstore.org/)

```
pass generate user-password 20 --no-symbols
```

List current passwords:

```
pass
```

View the password:

```
pass user-password
```