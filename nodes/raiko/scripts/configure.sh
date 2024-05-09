#!/bin/bash

location=$(dirname "$(realpath "$0")")
destination="${1:-.}"
upstream="$location/../../../upstream"

if [[ ! -f "${destination}/.env" ]]; then
  cp "${destination}/.env.example" "${destination}/.env"
  preferred=""
  if [[ $USER == "azureuser" ]]; then preferred="DC4sv2-cc0e8d8"; fi
  read -r -e -p "RAIKO_VERSION: " -i "${preferred}" RAIKO_VERSION
  sed -i "s/RAIKO_VERSION=/RAIKO_VERSION=$RAIKO_VERSION/g" "${destination}/.env"
  read -r -e -p "PCCS_VERSION: " -i "${preferred}" PCCS_VERSION
  sed -i "s/PCCS_VERSION=/PCCS_VERSION=$PCCS_VERSION/g" "${destination}/.env"
fi

crt_path="${destination}/data/pccs/file.crt"
if [[ ! -f "$crt_path" ]]; then
  openssl genrsa -out "${destination}/data/pccs/private.pem" 2048
  chmod 644 "${destination}/data/pccs/private.pem"
  openssl req -new -subj "/C=US" -key "${destination}/data/pccs/private.pem" -out "${destination}/data/pccs/csr.pem"
  openssl x509 -req -days 365 -in "${destination}/data/pccs/csr.pem" -signkey "${destination}/data/pccs/private.pem" -out ${crt_path}
  rm -rf "${destination}/data/pccs/csr.pem"
fi

config_path="${destination}/data/pccs/default.json"
if [[ ! -f "$config_path" ]]; then
  cp "$upstream/raiko/docker/pccs-defaut-example.json" "${config_path}"
  chmod 644 "${config_path}"

  read -r -e -p "API_KEY: " -i "${API_KEY}" API_KEY
  if [[ -n "$API_KEY" ]]; then
    sed -i "s/\YOUR_API_KEY/$API_KEY/g" "${config_path}"
  fi

  read -r -e -p "ADMIN_TOKEN: " -i "$(openssl rand -hex 24)" ADMIN_TOKEN
  sed -i "s/\YOUR_USER_TOKEN_HASH/$(echo -n "$ADMIN_TOKEN" | sha512sum | tr -d '[:space:]-')/g" "${config_path}"
  echo "ADMIN_TOKEN=$ADMIN_TOKEN" >> "${destination}/.env"

  read -r -e -p "USER_TOKEN: " -i "$(openssl rand -hex 24)" USER_TOKEN
  sed -i "s/\YOUR_ADMIN_TOKEN_HASH/$(echo -n "$USER_TOKEN" | sha512sum | tr -d '[:space:]-')/g" "${config_path}"
  echo "USER_TOKEN=$USER_TOKEN" >> "${destination}/.env"
fi
