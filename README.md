# Terragrunt Helpers

> An [Oh My Zsh](https://ohmyz.sh/) plugin that provides aliases and helper functions for working with [Terragrunt](https://terragrunt.gruntwork.io/).

## Requirements

- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fd](https://github.com/sharkdp/fd)

## Installation

Clone this repository into your Oh My Zsh custom plugins directory and enable it:

```bash
git clone https://github.com/sebastianmohaupt/terragrunt-helpers.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/terragrunt-helpers
```

Then add `terragrunt-helpers` to your plugins list in `~/.zshrc`:

```bash
plugins=(... terragrunt-helpers)
```

## Environment Variables

`TERRAFORM_MODULES_PATH` must point to your Terraform modules root directory.

The plugin also sets the following variables to enable provider caching (see [Terraform Provider Plugin Cache](https://developer.hashicorp.com/terraform/cli/config/config-file#provider-plugin-cache) and [Terragrunt Provider Cache](https://terragrunt.gruntwork.io/docs/features/provider-cache/)):

| Variable               | Value                             |
| ---------------------- | --------------------------------- |
| `TF_PLUGIN_CACHE_DIR`  | `$HOME/.terraform.d/plugin-cache` |
| `TG_PROVIDER_CACHE`    | `1`                               |
| `TG_PROVIDER_CACHE_DIR`| `$TF_PLUGIN_CACHE_DIR`            |

## Functions

### `_tgts`

Extracts the sub-path from the `source` variable in the current `terragrunt.hcl` and runs `terragrunt <action> --source $TERRAFORM_MODULES_PATH/<sub-path>`.

### `tgw`

Prints the resolved local source path for the current `terragrunt.hcl` without running any Terragrunt command. Useful for verifying which module directory would be used.

**Example** — Given this `terragrunt.hcl`:

```hcl
include "root" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${include.root.locals.source_base_url}/sqs-queue?ref=v0.0.1"
}

inputs = {}
```

Running `_tgts apply` executes:

```bash
terragrunt apply --source $TERRAFORM_MODULES_PATH/sqs-queue
```

## Aliases

### Basic

| Alias  | Command              |
| ------ | -------------------- |
| `tg`   | `terragrunt`         |
| `tga`  | `terragrunt apply`   |
| `tgp`  | `terragrunt plan`    |
| `tgd`  | `terragrunt destroy` |
| `tgi`  | `terragrunt init`    |
| `tgiu` | `terragrunt init -upgrade` |
| `tgo`  | `terragrunt output`  |
| `tgv`  | `terragrunt validate`|
| `tgs`  | `terragrunt show`    |
| `tgf`  | `terragrunt fmt`     |

### State

| Alias  | Command                  |
| ------ | ------------------------ |
| `tgsl` | `terragrunt state list`  |
| `tgss` | `terragrunt state show`  |
| `tgsr` | `terragrunt state rm`    |
| `tgsm` | `terragrunt state mv`    |

### Local Source (`_tgts`)

| Alias   | Command                |
| ------- | ---------------------- |
| `tgas`  | `_tgts apply`          |
| `tgps`  | `_tgts plan`           |
| `tgds`  | `_tgts destroy`        |
| `tgis`  | `_tgts import`         |
| `tgsps` | `_tgts state pull`     |
| `tgspus`| `_tgts state push`     |
| `tgius` | `_tgts init -upgrade`  |

### Run-All

| Alias    | Command                                                       |
| -------- | ------------------------------------------------------------- |
| `tgaall` | `terragrunt run --all apply --non-interactive --parallelism 10`  |
| `tgpall` | `terragrunt run --all plan --non-interactive --parallelism 10`   |
| `tgdall` | `terragrunt run --all destroy --non-interactive --parallelism 10` *(with confirmation prompt)* |
| `tgiall` | `terragrunt run --all init --non-interactive --parallelism 10`    |
| `tgiuall`| `terragrunt run --all init -upgrade --non-interactive --parallelism 10` |
| `tgoall` | `terragrunt run --all output --non-interactive --parallelism 10`  |
| `tgvall` | `terragrunt run --all validate --non-interactive --parallelism 10`|

### Run-All with Source Override

| Alias     | Command                                              |
| --------- | ---------------------------------------------------- |
| `tgasall` | `tgaall --source $(dirname $TERRAFORM_MODULES_PATH)` |
| `tgpsall` | `tgpall --source $(dirname $TERRAFORM_MODULES_PATH)` |
| `tgdsall` | `tgdall --source $(dirname $TERRAFORM_MODULES_PATH)` |

### Utilities

| Alias | Command                                    |
| ----- | ------------------------------------------ |
| `tgc` | `fd -t d -H -I .terragrunt-cache -X rm -rf` |
| `tgw` | Prints the resolved local source path  |

`tgc` recursively finds and removes all `.terragrunt-cache` directories. `tgw` resolves and prints the module path from the current `terragrunt.hcl`.
