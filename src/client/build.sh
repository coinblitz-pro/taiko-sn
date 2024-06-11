#!/bin/sh

docker buildx build \
  --platform=linux/amd64,linux/arm64 \
  --build-context upstream=../../upstream/taiko-mono \
  --push -t lagunovsky/taiko-client:0.26.0 \
  .
