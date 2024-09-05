#!/bin/bash

path="services/proposer"

if [[ ! -f "${path}/.env" ]]; then
  envsubst < "${path}/.env.template" > "${path}/.env"
fi
