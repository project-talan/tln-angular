#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker load -i ${TLN_COMPONENT_ID}-${TLN_COMPONENT_VERSION}.tar