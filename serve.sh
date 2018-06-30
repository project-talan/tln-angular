#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
ng server --host=${COMPONENT_PARAM_LSTN} --port=${COMPONENT_PARAM_PORT}
