#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker build \
  -t ${COMPONENT_ID}:${COMPONENT_VERSION} .
