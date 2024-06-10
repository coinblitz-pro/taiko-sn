#!/bin/bash

set -eo pipefail

action=${1}

if [ "${action}" == "driver" ]; then
  /commands/driver
elif [ "${action}" == "proposer" ]; then
  /commands/proposer
elif [ "${action}" == "prover" ]; then
  /commands/prover
else
  echo "Usage: $0 <action>"
  echo "Actions:"
  echo "  driver    Start the driver"
  echo "  proposer  Start the proposer"
  echo "  prover    Start the prover"
  exit 0
fi
