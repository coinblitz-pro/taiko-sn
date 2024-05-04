#!/bin/bash

set -e pipefail

read -r -e -p "Swap size: " -i "$(free -g | grep -oP '\d+' | head -n 1)g" SWAP_SIZE
sudo fallocate -l "${SWAP_SIZE}" /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

sysctl vm.swappiness=5
echo 'vm.swappiness=5' | sudo tee -a /etc/sysctl.conf

sysctl vm.vfs_cache_pressure=50
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf

sudo apt update && sudo apt upgrade -y
if ! command -v docker > /dev/null 2>&1; then
  curl https://get.docker.com | sh
  if [[ $USER != "root" ]]; then
    sudo usermod -aG docker "$USER"
    echo "⚠️ You need logging out and back in again"
  fi
fi
