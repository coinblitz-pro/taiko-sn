#!/bin/bash

set -e

crt_path="data/pccs/file.crt"
if [[ ! -f "$crt_path" ]]; then
  openssl genrsa -out data/pccs/private.pem 2048
  chmod 644 data/pccs/private.pem
  openssl req -new -key data/pccs/private.pem -out data/pccs/csr.pem
  openssl x509 -req -days 365 -in data/pccs/csr.pem -signkey data/pccs/private.pem -out ${crt_path}
  rm -rf data/pccs/csr.pem
fi

config_path="data/pccs/default.json"
if [[ ! -f "$config_path" ]]; then
  cp ./src/pccs/default.json ${config_path}
  chmod 644 ${config_path}

  echo "API_KEY:" && read -r API_KEY
  if [[ -z "$API_KEY" ]]; then
    sed -i "s/\$API_KEY/$API_KEY/g" ${config_path}
  fi

  read -r -e -p "ADMIN_TOKEN: " -i "$(openssl rand -hex 24)" ADMIN_TOKEN
  sed -i "s/\$ADMIN_TOKEN_HASH/$(echo -n "$ADMIN_TOKEN" | sha512sum | tr -d '[:space:]-')/g" ${config_path}
  echo "ADMIN_TOKEN=$ADMIN_TOKEN" >> .env

  read -r -e -p "USER_TOKEN: " -i "$(openssl rand -hex 24)" USER_TOKEN
  sed -i "s/\$USER_TOKEN_HASH/$(echo -n "$USER_TOKEN" | sha512sum | tr -d '[:space:]-')/g" ${config_path}
  echo "USER_TOKEN=$USER_TOKEN" >> .env
fi
