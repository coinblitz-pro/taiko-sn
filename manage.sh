#!/bin/bash

git submodule update --init upstream/taiko-mono && sleep 0.2
git submodule update --init upstream/raiko && sleep 0.2
git submodule update --init upstream/simple-taiko-node && sleep 0.2

action=${1:-help}

if [ "${action}" == "help" ]; then
  echo "Usage: $0 <action>"
  echo "Actions:"
  echo "  ubuntu.prepare  Prepare the ubuntu environment"
  echo "  raiko.prepare   Prepare the environment for running Raiko"
  echo "  raiko.setup     Setup a Raiko node"
  echo "  prover.setup    Setup a light node"
  echo "  prover.up       Start a light node"
  exit 0
fi

if [ "${action}" == "raiko.prepare" ]; then
  nodes/raiko/scripts/prepare.sh
elif [ "${action}" == "raiko.setup" ]; then
  scripts/raiko.setup.sh
elif [ "${action}" == "raiko.register" ]; then
  scripts/raiko.register.sh
fi

if [ "${action}" == "prover.setup" ]; then
  scripts/prover.setup.sh
elif [ "${action}" == "prover.up" ]; then
  scripts/prover.up.sh
fi

if [ "${action}" == "ubuntu.prepare" ]; then
  set -e pipefail

  read -r -e -p "Swap size: " -i "$(free -g | grep -oP '\d+' | head -n 1)g" SWAP_SIZE

  fallocate -l "${SWAP_SIZE}" /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

  sysctl vm.swappiness=5
  echo 'vm.swappiness=5' | sudo tee -a /etc/sysctl.conf

  sysctl vm.vfs_cache_pressure=50
  echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
fi
