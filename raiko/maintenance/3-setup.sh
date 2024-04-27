#!/bin/bash

set -e

openssl genrsa -out data/pccs/private.pem 2048
chmod 644 data/pccs/private.pem
openssl req -new -key data/pccs/private.pem -out data/pccs/csr.pem
openssl x509 -req -days 365 -in data/pccs/csr.pem -signkey data/pccs/private.pem -out data/pccs/file.crt
rm -rf data/pccs/csr.pem

cp ./src/pccs/default.json ./data/pccs/default.json
chmod 644 ./data/pccs/default.json

echo "API_KEY:" && read -r API_KEY
if [[ -z "$API_KEY" ]]; then
  sed -i "s/\$API_KEY/$API_KEY/g" ./data/pccs/default.json
fi

read -r -e -p "ADMIN_TOKEN: " -i "$(openssl rand -hex 24)" ADMIN_TOKEN
sed -i "s/\$ADMIN_TOKEN_HASH/$(echo -n "$ADMIN_TOKEN" | sha512sum | tr -d '[:space:]-')/g" ./data/pccs/default.json

read -r -e -p "USER_TOKEN: " -i "$(openssl rand -hex 24)" USER_TOKEN
sed -i "s/\$USER_TOKEN_HASH/$(echo -n "$USER_TOKEN" | sha512sum | tr -d '[:space:]-')/g" ./data/pccs/default.json
