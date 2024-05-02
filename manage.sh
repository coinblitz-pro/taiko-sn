#!/bin/bash

set -eu -o pipefail

git submodule update --init upstream/taiko-mono && sleep 0.5
git submodule update --init upstream/raiko && sleep 0.5
git submodule update --init upstream/simple-taiko-node && sleep 1

action=${1:-help}

if [ "${action}" == "help" ]; then
  echo "Usage: $0 <action>"
  echo "Actions:"
  echo "  prepare: Prepare the environment for running Raiko"
  echo "  light.setup: Setup a light node"
  echo "  raiko.setup: Setup a Raiko node"
  exit 0
fi

if [ "${action}" == "raiko.prepare" ]; then
  nodes/raiko/scripts/prepare.sh
fi

if [ "${action}" == "raiko.setup" ]; then
  scripts/light-node.setup.sh
fi

if [ "${action}" == "light.setup" ]; then
  scripts/light.setup.sh
fi
