#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
#~/projects/sonar-scanner-3.0.3.778/bin/sonar-scanner -X