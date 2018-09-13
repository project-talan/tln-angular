#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker load -i ${COMPONENT_ID}-${COMPONENT_VERSION}.tar
