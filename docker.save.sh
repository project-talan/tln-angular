#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker save -o ${TLN_COMPONENT_ID}-${TLN_COMPONENT_VERSION}.tar ${TLN_COMPONENT_ID}:${TLN_COMPONENT_VERSION}