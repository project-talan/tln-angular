#!/bin/bash -e
. ./.env.sh
ng serve --host=${COMPONENT_PARAM_LSTN} --port=${COMPONENT_PARAM_PORT}
