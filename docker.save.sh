#!/bin/bash -e
. ./.env.sh
docker save -o ${COMPONENT_ID}-${COMPONENT_VERSION}.tar ${COMPONENT_ID}:${COMPONENT_VERSION}
