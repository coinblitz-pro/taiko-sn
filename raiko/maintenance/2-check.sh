#!/bin/bash

echo "API_KEY:" && read -r API_KEY

PCKIDRetrievalTool -f /tmp/pckid.csv

pckid=$(cat /tmp/pckid.csv)
rm /tmp/pckid.csv

ppid=$(echo "$pckid" | awk -F "," '{print $1}')
cpusvn=$(echo "$pckid" | awk -F "," '{print $3}')
pcesvn=$(echo "$pckid" | awk -F "," '{print $4}')
pceid=$(echo "$pckid" | awk -F "," '{print $2}')

curl -v "https://api.trustedservices.intel.com/sgx/certification/v4/pckcert?encrypted_ppid=${ppid}&cpusvn=${cpusvn}&pcesvn=${pcesvn}&pceid=${pceid}" -H "Ocp-Apim-Subscription-Key:${API_KEY}" 2>&1 | grep -i "SGX-FMSPC"
