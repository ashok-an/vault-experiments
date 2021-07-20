#!/bin/bash

export VAULT_ADDR=http://127.0.0.1:8200
[[ "$1" ]] && export VAULT_TOKEN="$1"

[[ "${VAULT_TOKEN}" ]] || { echo "Usage: $0 <vault-root-token>"; exit 2 ; }

# list the leases
echo "Active leases ..."
vault list --format=json sys/leases/lookup/database/creds/readonly | jq -r

# get the first lease
LEASE_ID=$(vault list --format=json sys/leases/lookup/database/creds/readonly | jq -r ".[0]")
echo "Lease ID: ${LEASE_ID}"

# renew
echo "Renew ${LEASE_ID} ..."
vault lease renew database/creds/readonly/$LEASE_ID

# revoke
echo "Revoke ${LEASE_ID} ..."
vault lease revoke database/creds/readonly/$LEASE_ID

# list
echo "Active leases ... (after revoke)"
vault list --format=json sys/leases/lookup/database/creds/readonly | jq -r

