#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
ng lint ${COMPONENT_KEY} --format=prose --type-check=true
