## What is this?
Oh My Zsh plugin for working with [terragrunt](https://terragrunt.gruntwork.io/).
## Requirements
- [ripgrep](https://github.com/BurntSushi/ripgrep) needs to be installed
- [fd](https://github.com/sharkdp/fd) needs to be installed
## How to use?
Clone this repository in your `$ZSH/custom/plugins` directory and add `terragrunt-helpers` to your `plugins` list in `~/.zshrc`.
## Environment variables
- `TERRAFORM_MODULES_PATH` must point to your current terraform modules root directory.
## Functions
The `_tgts` functions extracts the subdirectories defined in the `source` variable in the current `terragrunt.hcl` file and executes `terragrunt ACTION --source $TERRAFORM_MODULES_PATH/source`. Take for example the following `terragrunt.hcl` file:
```bash
include "root" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${include.root.locals.source_base_url}/sqs-queue?ref=v0.0.1"
}

inputs = {}
```
Then for example the call `_tgas apply` will execute
```bash
terragrunt apply --source $TERRAFORM_MODULES_PATH/sqs-queue
```

## Aliases
| Alias     | Command                   |
| --------- | ------------------------- |
| `tg`      | `terragrunt`              |
| `tga`     | `terragrunt apply`        |
| `tgp`     | `terragrunt plan`         |
| `tgd`     | `terragrunt destroy`      |
| `tgas`    | `_tgts apply`                                                                                                                                                                              |
| `tgps`    | `_tgts plan`                                                                                                                                                                               |
| `tgds`    | `_tgts destroy`                                                                                                                                                                            |
| `tgis`    | `_tgts import`                                                                                                                                                                             |
| `tgsps`   | `_tgts state push`|
| `tgius` | `_tgts init -upgrade` |
| `tgaall`  | `terragrunt run-all apply --non-interactive --parallelism 10`                                                                                                        |
| `tgpall`  | `terragrunt run-all plan --non-interactive --parallelism 10`                                                                                                         |
| `tgdall`  | `tgdall(){ local result; read "result?Are you sure (y/n)? "; [[ $result =~ ^[Yy]$ ]] && tg run-all destroy --non-interactive --parallelism 10 "$@" }; noglob tgdall` |
| `tgasall` | `tgaall --source $(dirname $TERRAFORM_MODULES_PATH)`                                                                                                                            |
| `tgpsall` | `tgpall --source $(dirname $TERRAFORM_MODULES_PATH)`                                                                                                                            |
| `tgdsall` | `tgdall --source $(dirname $TERRAFORM_MODULES_PATH)`                                                                                                                            |
| `clearTerragruntCache` | `fd -t d -H -I .terragrunt-cache -X rm -rf`                                                                                                                                   |
