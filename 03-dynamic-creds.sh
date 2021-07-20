#!/bin/bash

export VAULT_ADDR=http://127.0.0.1:8200
[[ "$1" ]] && export VAULT_TOKEN="$1"

[[ "${VAULT_TOKEN}" ]] || { echo "Usage: $0 <vault-root-token>"; exit 2 ; }

# create policy
vault policy write db_creds db_creds.hcl

# create a token with the policy
vault token create -policy="db_creds"

# create credentials with consul-template
echo "create with consul-template"
consul-template -template="config.yaml.tpl:/tmp/config.yaml" -once

# get credentials with envconsul
echo "get with envconsul"
envconsul -upcase -secret database/creds/readonly ./app.sh | jq -r
