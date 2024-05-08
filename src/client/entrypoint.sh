#!/bin/bash

set -eo pipefail

action=${1}

if [ "${action}" == "driver" ]; then
  /scripts/driver
elif [ "${action}" == "proposer" ]; then
  /scripts/proposer
elif [ "${action}" == "prover" ]; then
  /scripts/prover
else
  echo "Usage: $0 <action>"
  echo "Actions:"
  echo "  driver    Start the driver"
  echo "  proposer  Start the proposer"
  echo "  prover    Start the prover"
  exit 0
fi
