#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
docker stop ${PROJECT_KEY}
docker rmi ${PROJECT_KEY}:${PROJECT_VERSION}
