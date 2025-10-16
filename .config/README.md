## command to run docker in the current foler
```docker run -it --rm --gpus all \
    -v $SSH_AUTH_SOCK:/ssh-agent \
    -e SSH_AUTH_SOCK=/ssh-agent \
    -v (pwd):/work \
    -w /work \
    dev-env
```
## ~/.config/fish/config.fish

# Check if an SSH agent is running, if not, start one
```if test -z "$SSH_AUTH_SOCK"
    # Start the agent and capture its output
    eval (ssh-agent -c)

    # Add your key. It will ask for the passphrase here.
    ssh-add
end
```


