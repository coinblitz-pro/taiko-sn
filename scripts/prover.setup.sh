#!/bin/bash

path="nodes/prover"

rsync -a nodes/raiko/data ${path}

if [[ ! -f "${path}/.env" ]]; then
  envsubst < "${path}/.env.template" > "${path}/.env"
fi
