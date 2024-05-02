#!/bin/bash

set -e

if [[ ! -f "./.env" ]]; then
  cp .env.example .env
  echo "Available container versions: DC4sv2"
  read -r -e -p "RAIKO_VERSION: " -i "DC4sv2" RAIKO_VERSION
  sed -i "s/RAIKO_VERSION=/RAIKO_VERSION=$RAIKO_VERSION/g" .env
  read -r -e -p "PCCS_VERSION: " -i "DC4sv2" PCCS_VERSION
  sed -i "s/PCCS_VERSION=/PCCS_VERSION=$PCCS_VERSION/g" .env
fi

crt_path="./data/pccs/file.crt"
if [[ ! -f "$crt_path" ]]; then
  openssl genrsa -out ./data/pccs/private.pem 2048
  chmod 644 ./data/pccs/private.pem
  openssl req -new -subj "/C=US" -key ./data/pccs/private.pem -out ./data/pccs/csr.pem
  openssl x509 -req -days 365 -in ./data/pccs/csr.pem -signkey ./data/pccs/private.pem -out ${crt_path}
  rm -rf data/pccs/csr.pem
fi

config_path="data/pccs/default.json"
if [[ ! -f "$config_path" ]]; then
  cp ../upstream/raiko/docker/pccs-defaut-example.json ${config_path}
  chmod 644 ${config_path}

  read -r -e -p "API_KEY: " -i "${API_KEY}" API_KEY
  if [[ -n "$API_KEY" ]]; then
    sed -i "s/\YOUR_API_KEY/$API_KEY/g" ${config_path}
  fi

  read -r -e -p "ADMIN_TOKEN: " -i "$(openssl rand -hex 24)" ADMIN_TOKEN
  sed -i "s/\YOUR_USER_TOKEN_HASH/$(echo -n "$ADMIN_TOKEN" | sha512sum | tr -d '[:space:]-')/g" ${config_path}
  echo "ADMIN_TOKEN=$ADMIN_TOKEN" >> .env

  read -r -e -p "USER_TOKEN: " -i "$(openssl rand -hex 24)" USER_TOKEN
  sed -i "s/\YOUR_ADMIN_TOKEN_HASH/$(echo -n "$USER_TOKEN" | sha512sum | tr -d '[:space:]-')/g" ${config_path}
  echo "USER_TOKEN=$USER_TOKEN" >> .env
fi
