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
  echo "  raiko.setup     Setup a raiko"
  echo "  raiko.register  Register a raiko"
  echo "  raiko.up        Start a raiko"
  echo "  prover.setup    Setup a prover"
  echo "  prover.up       Start a prover"
  exit 0
fi

if [ "${action}" == "raiko.prepare" ]; then
  nodes/raiko/scripts/prepare.sh
elif [ "${action}" == "raiko.setup" ]; then
  scripts/raiko.setup.sh
elif [ "${action}" == "raiko.register" ]; then
  scripts/raiko.register.sh
elif [ "${action}" == "raiko.up" ]; then
  scripts/raiko.up.sh
elif [ "${action}" == "raiko" ]; then
  cd "nodes/raiko"
fi

if [ "${action}" == "prover.setup" ]; then
  scripts/prover.setup.sh
elif [ "${action}" == "prover.up" ]; then
  scripts/prover.up.sh
elif [ "${action}" == "prover" ]; then
  cd "nodes/prover"
fi

if [ "${action}" == "ubuntu.prepare" ]; then
  scripts/ubuntu.prepare.sh
fi
