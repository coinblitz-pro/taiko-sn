#!/bin/sh

docker buildx build \
  --platform=linux/amd64,linux/arm64 \
  --build-context upstream=../../../upstream \
  --push -t lagunovsky/taiko-client:hekla-proposer \
  .
