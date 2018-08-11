#!/bin/bash -e
. ./.env.sh
docker load -i ${COMPONENT_ID}-${COMPONENT_VERSION}.tar
