#!/bin/bash

set -e

echo "PRIVATE_KEY:" && read -r PRIVATE_KEY

# init raiko
docker compose run --rm raiko --init
V3_QUOTE_BYTES=$(jq '.quote' < data/raiko/config/bootstrap.json)

# register
cd src/taiko-mono/packages/protocol
pnpm install
pnpm compile
registration_process=$(PRIVATE_KEY=${PRIVATE_KEY} FORK_URL=https://ethereum-holesky-rpc.publicnode.com ./script/config_dcap_sgx_verifier.sh --quote "${V3_QUOTE_BYTES}")
echo "$registration_process"
cd ../../..

# save SGX_INSTANCE_ID
SGX_INSTANCE_ID=$(registration_process | grep -oP 'InstanceAdded\(id: \K\d+')
echo "SGX_INSTANCE_ID=$SGX_INSTANCE_ID" > .env
