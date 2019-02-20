#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
ng serve --host=${TLN_COMPONENT_PARAM_LSTN} --port=${TLN_COMPONENT_PARAM_PORT}