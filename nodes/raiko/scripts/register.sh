#!/bin/bash

set -e

location=$(dirname "$(realpath "$0")")
destination="${1:-.}"
upstream="$location/../../../upstream"
timestamp=$(date +%s)

priv_key_path="${destination}/data/raiko/secrets/priv.key"
if [[ -f "$priv_key_path" ]]; then
  read -r -e -p "Do you want register again? (Y/n) " PRIVATE_KEY
  if [ "$RESP" = "N" ] || [ "$RESP" = "n" ]; then
    exit 0
  fi

  docker compose --project-directory "${destination}" down
  sudo mv "${priv_key_path}" "${priv_key_path}.${timestamp}"
  cp "${destination}/.env" "${destination}/.env.${timestamp}"
fi

bootstrap_path="${destination}/data/raiko/config/bootstrap.json"
if [[ ! -f "$bootstrap_path" ]]; then
    docker compose --project-directory "${destination}" run --rm raiko --init
fi
V3_QUOTE_BYTES=$(jq -r '.quote' < "$bootstrap_path")

read -r -e -p "PRIVATE_KEY: " -i "${PRIVATE_KEY}" PRIVATE_KEY
cd "$upstream/taiko-mono/packages/protocol"

pnpm install
pnpm compile

if ! registration_process=$(PRIVATE_KEY=${PRIVATE_KEY} FORK_URL=https://ethereum-holesky-rpc.publicnode.com ./script/config_dcap_sgx_verifier.sh --quote "${V3_QUOTE_BYTES}")
then
  echo "$registration_process"
  echo "Failed to register SGX instance"
  exit 1
fi

echo "$registration_process"
cd -

SGX_INSTANCE_ID=$(echo "${registration_process}" | grep -oP -m 1 'register sgx instance index: \K\d+')

echo "Registered SGX instance with ID: $SGX_INSTANCE_ID"
sed -i "s/RAIKO_SGX_INSTANCE_ID=/RAIKO_SGX_INSTANCE_ID=$SGX_INSTANCE_ID/g" "${destination}/.env"
