#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
ng lint ${COMPONENT_ID} --format=prose --type-check=true
