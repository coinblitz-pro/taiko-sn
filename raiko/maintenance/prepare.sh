#!/bin/bash

set -e

# clone repositories
git submodule update --init

# install dependencies
curl https://get.docker.com | sh
wget -qO- https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | sudo tee /etc/apt/keyrings/intel-sgx-keyring.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/intel-sgx-keyring.asc arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/intel-sgx.list
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt install -y nodejs sgx-pck-id-retrieval-tool libsgx-epid jq -y
npm install -g pnpm
curl -L https://foundry.paradigm.xyz | bash
export PATH="$PATH:/root/.foundry/bin"
foundryup

# get user input
echo "API_KEY:" && read -r API_KEY
echo "USER_TOKEN:" && read -r USER_TOKEN
echo "ADMIN_TOKEN:" && read -r ADMIN_TOKEN

# check platform
PCKIDRetrievalTool -f /tmp/pckid.csv
pckid=$(cat /tmp/pckid.csv)
rm /tmp/pckid.csv
ppid=$(echo "$pckid" | awk -F "," '{print $1}')
cpusvn=$(echo "$pckid" | awk -F "," '{print $3}')
pcesvn=$(echo "$pckid" | awk -F "," '{print $4}')
pceid=$(echo "$pckid" | awk -F "," '{print $2}')
fmspc=$(curl -v "https://api.trustedservices.intel.com/sgx/certification/v4/pckcert?encrypted_ppid=${ppid}&cpusvn=${cpusvn}&pcesvn=${pcesvn}&pceid=${pceid}" -H "Ocp-Apim-Subscription-Key:${API_KEY}" 2>&1 | grep -i "SGX-FMSPC: 00606A000000")
if [[ -z "$fmspc" ]]; then
  echo "FMSPC not found or invalid ($fmspc)"
  exit 1
fi

# setup pccs certificate
openssl genrsa -out data/pccs/private.pem 2048
chmod 644 data/pccs/private.pem
openssl req -new -key data/pccs/private.pem -out data/pccs/csr.pem
openssl x509 -req -days 365 -in data/pccs/csr.pem -signkey data/pccs/private.pem -out data/pccs/file.crt
rm -rf data/pccs/csr.pem

# setup pccs config
USER_TOKEN_HASH=$(echo -n "$USER_TOKEN" | sha512sum | tr -d '[:space:]-')
ADMIN_TOKEN_HASH=$(echo -n "$ADMIN_TOKEN" | sha512sum | tr -d '[:space:]-')
cp ./src/pccs/default.json ./data/pccs/default.json
sed -i "s/\$API_KEY/$API_KEY/g" ./data/pccs/default.json
sed -i "s/\$USER_TOKEN_HASH/$USER_TOKEN_HASH/g" ./data/pccs/default.json
sed -i "s/\$ADMIN_TOKEN_HASH/$ADMIN_TOKEN_HASH/g" ./data/pccs/default.json
chmod 644 ./data/pccs/default.json

# build
docker compose build
