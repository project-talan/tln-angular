#!/bin/bash -e
. ./.env.sh
ng test ${COMPONENT_ID} --code-coverage
