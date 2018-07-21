#!/bin/bash -e
. ./.env.sh
ng lint ${COMPONENT_ID} --format=prose --type-check=true
