#!/bin/bash

{
  echo
  date
  docker compose exec -ti "${container:-engine}" geth attach --datadir /data/taiko-geth --exec "admin.peers.map(p => console.log(p.enode))" | grep 'enode.*$'
} >> ./peers.txt
