#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker run -d --rm \
  -p ${TLN_COMPONENT_PARAM_PORT}:80 \
  -p ${TLN_COMPONENT_PARAM_PORTS}:443 \
  --name ${TLN_COMPONENT_ID} ${TLN_COMPONENT_ID}:${TLN_COMPONENT_VERSION}