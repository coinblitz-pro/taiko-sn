#!/bin/bash

git submodule update --init upstream/simple-taiko-node && sleep 0.2

action=${1:-help}

if [ "${action}" == "help" ]; then
  echo "Usage: $0 <action>"
  echo "Actions:"
  echo "  ubuntu.prepare  Prepare the ubuntu environment"
  echo "  prover.setup    Setup a prover"
  echo "  prover.up       Start a prover"
  exit 0
fi

if [ "${action}" == "prover.setup" ]; then
  scripts/prover.setup.sh
elif [ "${action}" == "prover.up" ]; then
  scripts/prover.up.sh
fi

if [ "${action}" == "ubuntu.prepare" ]; then
  scripts/ubuntu.prepare.sh
fi
