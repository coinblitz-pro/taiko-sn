#!/bin/bash

peers=$(cat ./peers.txt | grep -o 'enode://.*$' | uniq)
for peer in $peers; do
  docker compose exec -ti "${container:-engine}" geth attach --datadir /data/taiko-geth --exec "admin.addPeer('${peer}')"
done
