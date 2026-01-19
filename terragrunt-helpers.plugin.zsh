
# Function to run "terragrunt COMMAND -source /path/to/your/terraform/module"
# without providing the path to the terraform module.
function _tgts() {
    local sub_module sub_module_dir
    sub_module=$(rg 'source = "\$\{.*\}/([/\w-]*).*"' terragrunt.hcl -or '$1')
    if [ $? -ne 0 ]; then
        echo -e "\033[0;31mError: cannot extract subdirectories in source variable.\033[0m" >&2
        return 1
    fi
    sub_module_dir="${TERRAFORM_MODULES_PATH}/${sub_module}"
    echo "source: $sub_module_dir"
    terragrunt "$@" --source  $sub_module_dir
}

# Activate the following three exports if you want to use caching.
# See https://developer.hashicorp.com/terraform/cli/config/config-file#provider-plugin-cache
# and https://terragrunt.gruntwork.io/docs/features/provider-cache/ 
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
export TG_PROVIDER_CACHE=1
export TG_PROVIDER_CACHE_DIR=$TF_PLUGIN_CACHE_DIR

alias tg='terragrunt'

alias tga='tg apply'
alias tgp='tg plan'
alias tgd='tg destroy'

# alias tgas='tga --source'
# alias tgps='tgp --source'
# alias tgds='tgd --source'
alias tgas='_tgts apply'
alias tgps='_tgts plan'
alias tgds='_tgts destroy'
alias tgis='_tgts import'
alias tgsps='_tgts state pull'
alias tgspus='_tgts state push'
alias tgius='_tgts init -upgrade'

alias tgaall='tg run --all apply --non-interactive --parallelism 10'
alias tgdall='tgdall(){ local result; read "result?Are you sure (y/n)? "; [[ $result =~ ^[Yy]$ ]] && tg run --all destroy --non-interactive --parallelism 10 "$@" }; noglob tgdall'
alias tgpall='tg run --all plan --non-interactive --parallelism 10'
alias tgasall='tgaall --source $(dirname $TERRAFORM_MODULES_PATH)'
alias tgpsall='tgpall --source $(dirname $TERRAFORM_MODULES_PATH)'
alias tgdsall='tgdall --source $(dirname $TERRAFORM_MODULES_PATH)'

alias clearTerragruntCache='fd -t d -H -I .terragrunt-cache -X rm -rf'