#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
ng serve --host=${COMPONENT_PARAM_LSTN} --port=${COMPONENT_PARAM_PORT}