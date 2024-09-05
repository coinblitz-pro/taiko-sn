#!/bin/bash

path="services/prover"

if [[ ! -f "${path}/.env" ]]; then
  envsubst < "${path}/.env.template" > "${path}/.env"
fi
