#!/bin/bash

export VAULT_ADDR=http://127.0.0.1:8200
[[ "$1" ]] && export VAULT_TOKEN="$1"

[[ "${VAULT_TOKEN}" ]] || { echo "Usage: $0 <vault-root-token>"; exit 2 ; }

# enable db secrets engine
vault secrets enable database

# configure pgsql engine
vault write database/config/postgresql \
     plugin_name=postgresql-database-plugin \
     connection_url="postgresql://{{username}}:{{password}}@localhost:5432/postgres?sslmode=disable" \
     allowed_roles=readonly \
     username="root" \
     password="rootpassword"

# apply username template
vault write database/config/postgresql \
    username_template="devx-demo-{{.RoleName}}-{{random 8}}"

# apply a password policy: example_policy
vault write sys/policies/password/example policy=@example_policy.hcl

# generate a password
echo "# Sample password"
vault read --format=json sys/policies/password/example/generate | jq -r ".data"

# create a role: readonly
vault write database/roles/readonly \
      db_name=postgresql \
      creation_statements=@readonly.sql \
      default_ttl=5m \
      max_ttl=2h

# create credentials
for i in $(seq 1 3); do
  echo "# Sample credential [${i}]"
  vault read --format=json database/creds/readonly | jq -r ".data"
  sleep 5
done
