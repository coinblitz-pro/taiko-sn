#!/bin/bash

set -eu -o pipefail

if [ ! -d "upstream/taiko-mono" ]; then
  git submodule update --init upstream/taiko-mono && sleep 0.25
  git submodule update --init upstream/raiko && sleep 0.25
  git submodule update --init upstream/simple-taiko-node
fi

if [ "$1" == "prepare" ]; then
  sudo nodes/raiko/maintenance/raiko.prepare.sh
fi

if [ "$1" == "light.setup" ]; then
  maintenance/light.setup.sh
fi

if [ "$1" == "raiko.setup" ]; then
  maintenance/light-node.setup.sh
fi
