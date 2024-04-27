#!/bin/bash

set -e

# clone repositories
git submodule update --init

# install docker
curl https://get.docker.com | sh

# install sgx and jq
wget -qO- https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | sudo tee /etc/apt/keyrings/intel-sgx-keyring.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/intel-sgx-keyring.asc arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/intel-sgx.list
apt update && apt install -y \
    sgx-aesm-service \
    libsgx-aesm-launch-plugin \
    libsgx-aesm-epid-plugin \
    libsgx-aesm-quote-ex-plugin \
    libsgx-aesm-ecdsa-plugin \
    libsgx-dcap-quote-verify \
    libsgx-dcap-default-qpl \
    sgx-pck-id-retrieval-tool \
    jq

# install node
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt update && apt install nodejs -y
npm install -g pnpm

# install forge
curl -L https://foundry.paradigm.xyz | bash
~/.foundry/bin/foundryup
