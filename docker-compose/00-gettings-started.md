
You'll need docker installed.
Try something like [Rancher Desktop]() if you're on macOS or Windows (with WSL2.)

Then, run the following script.

```
./workspace.fish
```

This will boot up the workspace.

This excercise is driven using a few environment variables:

```
$WORKSPACE_DIR
```

Which maps the the directory containing the source to the the `$HOME/workspace` directory inside the container which contains the assets for this project (like files needed for the container build, helper scritps for this tutorial, etc...).

```
$RUNTIME_DIR
```

which maps to various locations inside the container so that files create during the examples are visiable outside the container.