#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker save -o ${COMPONENT_ID}-${COMPONENT_VERSION}.tar ${COMPONENT_ID}:${COMPONENT_VERSION}
