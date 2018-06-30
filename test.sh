#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
ng test ${COMPONENT_KEY} --code-coverage
