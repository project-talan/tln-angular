#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
ng test ${TLN_COMPONENT_ID} --code-coverage