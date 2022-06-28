# Deploy Action

    Available flags:
    - all: run all tasks
    - bundle: just bundle the deploy-package
    - clean: clean env

    This command is based on cargo make --env-file=./env/production.env

# Run deploy action with your profile

You should spcific an `env file` before you run this command.

- the `-t` flag can be with `Available flags`

```sh
just deploy <profile-name> '--env-file=./profiles/test/deploy.env -t all'
```
