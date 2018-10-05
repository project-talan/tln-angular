#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
if [ -d ./ssl ]
then
  envsubst '\${COMPONENT_ID} \${COMPONENT_PARAM_HOST}' > default.conf < default.conf.https.template
else
  envsubst '\${COMPONENT_PARAM_HOST}' > default.conf < default.conf.template
fi
docker build \
  -t ${COMPONENT_ID}:${COMPONENT_VERSION} .
