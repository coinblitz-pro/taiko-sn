#!/bin/bash

path="nodes/light"

cp "${path}/.env.example" "${path}/.env"
rsync -a nodes/raiko/data ${path}

sed -i "s@L1_ENDPOINT_HTTP=@L1_ENDPOINT_HTTP=${L1_ENDPOINT_HTTP}@g" "${path}/.env"
sed -i "s@L1_ENDPOINT_WS=@L1_ENDPOINT_WS=${L1_ENDPOINT_WS}@g" "${path}/.env"
sed -i "s@L1_BEACON_HTTP=@L1_BEACON_HTTP=${L1_BEACON_HTTP}@g" "${path}/.env"
sed -i "s@L2_ENDPOINT_HTTP=@L2_ENDPOINT_HTTP=${L2_ENDPOINT_HTTP}@g" "${path}/.env"
sed -i "s@L2_ENDPOINT_WS=@L2_ENDPOINT_WS=${L2_ENDPOINT_WS}@g" "${path}/.env"
sed -i "s@L2_ENDPOINT_AUTH=@L2_ENDPOINT_AUTH=${L2_ENDPOINT_AUTH}@g" "${path}/.env"
sed -i "s@L2_JWT_SECRET=@L2_JWT_SECRET=${L2_JWT_SECRET}@g" "${path}/.env"
sed -i "s@PROPOSER_PUBLIC_PROVER_ENDPOINTS=@PROPOSER_PUBLIC_PROVER_ENDPOINTS=${PROPOSER_PUBLIC_PROVER_ENDPOINTS}/@g" "${path}/.env"

nodes/raiko/scripts/configure.sh ${path}
nodes/raiko/scripts/register.sh ${path}
