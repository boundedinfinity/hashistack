We'll set up a GnuPG configuration, which we'll used in the next step to provision a local password manager to store various passwords, keys, tokens, certificates, etc.. which will be created during the build in an encrypted format.


This will be configured by using the

```
$GNUPGHOME
```

environment varible, which will store the configuration in a slightly non-standard location.  The outputs will be stored an an `XDG_CONFIG_HOME` compliant directory.

To view the location:

```
echo $GNUPGHOME
```

First ensure that the directory is created and it has correct permission:

```
mkdir --parents --verbose $GNUPGHOME
find $GNUPGHOME -type d | xargs -t chmod --verbose 700
```

We'll use a configuration file to initialize the the gpg keys.  The syntax of the file is using the [Unattended key generation](https://www.gnupg.org/documentation/manuals/gnupg/Unattended-GPG-key-generation.html#Unattended-GPG-key-generation) mode of gpg.

To view the contents of this file:

```
cat $WORKSPACE_DIR/gpg/batch.txt
```

Run the following helper script to manage some of the environment to make the gpg configuration work in the non home root directory:

```
$WORKSPACE_DIR/gpg/bootstrap.fish
```

Now generated the private key:

```
gpg --verbose --generate-key --batch $WORKSPACE_DIR/gpg/batch.txt
```

Now list the keys created:

```
gpg --list-secret-keys
```

From the list we'll be using the `crypto.user@server.com` private key.

And we'll double check the permissions are correctly set on the generated files:

```
find $GNUPGHOME -type d | xargs -t chmod --verbose 700
find $GNUPGHOME -type f | xargs -t chmod --verbose 600
```