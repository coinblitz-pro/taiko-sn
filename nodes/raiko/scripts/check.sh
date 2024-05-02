#!/bin/bash

read -r -e -p "API_KEY: " -i "${API_KEY}" API_KEY
PCKIDRetrievalTool -f /tmp/pckid.csv

params=$(awk -F "," '{print "encrypted_ppid="$1"&cpusvn="$3"&pcesvn="$4"&pceid="$2}' < /tmp/pckid.csv)
curl -v "https://api.trustedservices.intel.com/sgx/certification/v4/pckcert?$params" -H "Ocp-Apim-Subscription-Key:${API_KEY}" 2>&1 | grep -i "SGX-FMSPC"
