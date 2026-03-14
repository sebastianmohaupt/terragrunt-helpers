
# Run "terragrunt COMMAND --source /path/to/your/terraform/module"
# without providing the path to the terraform module.
# Extracts the module path after the interpolation closing brace in the source line.
function _tgts() {
    if [[ -z "$TERRAFORM_MODULES_PATH" ]]; then
        print -u2 "\e[0;31mError: TERRAFORM_MODULES_PATH is not set.\e[0m"
        return 1
    fi

    local sub_module
    sub_module=$(rg -o 'source\s*=\s*".*\}/([^"?]+)' terragrunt.hcl -r '$1') || {
        print -u2 "\e[0;31mError: cannot extract module path from source in terragrunt.hcl.\e[0m"
        return 1
    }

    local source_dir="${TERRAFORM_MODULES_PATH}/${sub_module}"
    echo "source: $source_dir"
    terragrunt "$@" --source "$source_dir"
}

# Provider caching
# See https://developer.hashicorp.com/terraform/cli/config/config-file#provider-plugin-cache
# and https://terragrunt.gruntwork.io/docs/features/provider-cache/
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export TG_PROVIDER_CACHE=1
export TG_PROVIDER_CACHE_DIR=$TF_PLUGIN_CACHE_DIR
[[ -d "$TF_PLUGIN_CACHE_DIR" ]] || mkdir -p "$TF_PLUGIN_CACHE_DIR"

alias tg='terragrunt'

alias tga='tg apply'
alias tgp='tg plan'
alias tgd='tg destroy'
alias tgi='tg init'
alias tgiu='tg init -upgrade'
alias tgo='tg output'
alias tgv='tg validate'
alias tgs='tg show'
alias tgf='tg fmt'
alias tgsl='tg state list'
alias tgss='tg state show'
alias tgsr='tg state rm'
alias tgsm='tg state mv'

alias tgas='_tgts apply'
alias tgps='_tgts plan'
alias tgds='_tgts destroy'
alias tgis='_tgts import'
alias tgsps='_tgts state pull'
alias tgspus='_tgts state push'
alias tgius='_tgts init -upgrade'

alias tgaall='tg run --all apply --non-interactive --parallelism 10'
alias tgpall='tg run --all plan --non-interactive --parallelism 10'
alias tgiall='tg run --all init --non-interactive --parallelism 10'
alias tgiuall='tg run --all init -upgrade --non-interactive --parallelism 10'
alias tgoall='tg run --all output --non-interactive --parallelism 10'
alias tgvall='tg run --all validate --non-interactive --parallelism 10'
function tgdall() {
    local result
    read "result?Are you sure (y/n)? "
    [[ $result =~ ^[Yy]$ ]] && tg run --all destroy --non-interactive --parallelism 10 "$@"
}
alias tgasall='tgaall --source $(dirname $TERRAFORM_MODULES_PATH)'
alias tgpsall='tgpall --source $(dirname $TERRAFORM_MODULES_PATH)'
alias tgdsall='tgdall --source $(dirname $TERRAFORM_MODULES_PATH)'

alias tgc='fd -t d -H -I .terragrunt-cache -X rm -rf'

# Print the resolved local source path for the current terragrunt.hcl
function tgw() {
    if [[ -z "$TERRAFORM_MODULES_PATH" ]]; then
        print -u2 "\e[0;31mError: TERRAFORM_MODULES_PATH is not set.\e[0m"
        return 1
    fi

    local sub_module
    sub_module=$(rg -o 'source\s*=\s*".*\}/([^"?]+)' terragrunt.hcl -r '$1') || {
        print -u2 "\e[0;31mError: cannot extract module path from source in terragrunt.hcl.\e[0m"
        return 1
    }
    echo "${TERRAFORM_MODULES_PATH}/${sub_module}"
}