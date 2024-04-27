#!/bin/bash

set -e

export PATH="$PATH:~/.foundry/bin"

echo "PRIVATE_KEY:" && read -r PRIVATE_KEY

# init raiko
bootstrap_path="data/raiko/config/bootstrap.json"
if [[ ! -f "$bootstrap_path" ]]; then
    docker compose run --rm raiko --init
fi
V3_QUOTE_BYTES=$(jq -r '.quote' < "$bootstrap_path")

# register
cd src/taiko-mono/packages/protocol
pnpm install
pnpm compile
registration_process=$(PRIVATE_KEY=${PRIVATE_KEY} FORK_URL=https://ethereum-holesky-rpc.publicnode.com ./script/config_dcap_sgx_verifier.sh --quote "${V3_QUOTE_BYTES}")
echo "$registration_process"
cd ../../..

# save SGX_INSTANCE_ID
SGX_INSTANCE_ID=$(echo "${registration_process}" | grep -oP 'InstanceAdded\(id: \K\d+')
echo "SGX_INSTANCE_ID=$SGX_INSTANCE_ID" > .env
