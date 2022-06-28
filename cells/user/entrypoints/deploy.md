# Deploy Action

    Available flags:
    - all: run all tasks
    - bundle: just bundle the deploy-package
    - clean: clean env

    The command is based on cargo make --env-file=./env/production.env

## run deploy action with your profile

You should spcific an `env file` before you run this command.

```sh
just deploy <profile-name> '--env-file=./profiles/test/deploy.env -t all'
```
