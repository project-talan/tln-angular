#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker build --build-arg PROJECT_PARAM_HOST=$PROJECT_PARAM_HOST \
             --build-arg PROJECT_PARAM_LSTN=$PROJECT_PARAM_LSTN \
             --build-arg PROJECT_PARAM_PORT=$PROJECT_PARAM_PORT \
             --build-arg PROJECT_PARAM_PORTS=$PROJECT_PARAM_PORTS \
             -t ${PROJECT_KEY}:${PROJECT_VERSION} .
