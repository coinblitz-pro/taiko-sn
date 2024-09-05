#!/bin/bash

path="services/prover"

docker compose --project-directory "${path}" up -d
