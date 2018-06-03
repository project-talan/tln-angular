#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker run -d --rm -p $PROJECT_PARAM_PORT:80 -p $PROJECT_PARAM_PORTS:443 --name ${PROJECT_KEY} ${PROJECT_KEY}:${PROJECT_VERSION}
