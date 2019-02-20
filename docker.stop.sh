#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker stop ${TLN_COMPONENT_ID}
docker rmi ${TLN_COMPONENT_ID}:${TLN_COMPONENT_VERSION}