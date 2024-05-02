#!/bin/bash

set -e

git submodule update --init upstream/taiko-mono && sleep 1
git submodule update --init upstream/raiko && sleep 1

curl https://get.docker.com | sh

ubuntu_version=$(lsb_release -rs)
if [ "$ubuntu_version" == "20.04" ]; then
  curl -fsSLo /usr/share/keyrings/intel-sgx-deb.key https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key
  echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/intel-sgx-deb.key] https://download.01.org/intel-sgx/sgx_repo/ubuntu focal main' > /etc/apt/sources.list.d/intel-sgx.list
elif [ "$ubuntu_version" == "22.04" ]; then
  wget -qO- https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key | tee /etc/apt/keyrings/intel-sgx-keyring.asc > /dev/null
  echo "deb [signed-by=/etc/apt/keyrings/intel-sgx-keyring.asc arch=amd64] https://download.01.org/intel-sgx/sgx_repo/ubuntu $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/intel-sgx.list
else
  echo "Unsupported Ubuntu version: $ubuntu_version"
fi

apt update && apt install -y \
  sgx-pck-id-retrieval-tool \
  libsgx-dcap-default-qpl \
  jq

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
apt update && apt install nodejs -y
npm install -g pnpm

curl -L https://foundry.paradigm.xyz | bash
~/.foundry/bin/foundryup
ln -s ~/.foundry/bin/forge /usr/bin/forge
