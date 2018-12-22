#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker stop ${COMPONENT_ID}
docker rmi ${COMPONENT_ID}:${COMPONENT_VERSION}