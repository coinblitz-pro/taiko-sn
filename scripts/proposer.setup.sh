#!/bin/bash

path="nodes/proposer"

if [[ ! -f "${path}/.env" ]]; then
  envsubst < "${path}/.env.template" > "${path}/.env"
fi
