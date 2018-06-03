#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
ng server --host=${PROJECT_PARAM_LSTN} --port=${PROJECT_PARAM_PORT}
