#!/bin/bash

path="nodes/light"

rsync -a nodes/raiko/data ${path}

if [[ ! -f "${path}/.env" ]]; then
  envsubst < "${path}/.env.template" > "${path}/.env"
fi

nodes/raiko/scripts/configure.sh ${path}
nodes/raiko/scripts/register.sh ${path}
