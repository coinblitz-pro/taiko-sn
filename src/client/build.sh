#!/bin/sh

docker buildx build \
  --platform=linux/amd64,linux/arm64 \
  --build-context upstream=../../upstream/taiko-client \
  --push -t lagunovsky/taiko-client:hekla \
  .
