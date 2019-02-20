#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
ng lint ${TLN_COMPONENT_ID} --format=prose --type-check=true