#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
rm -rf ./target || true
mkdir target
mkdir target/conf.d
if [ -d ./ssl ]
then
  envsubst '\${COMPONENT_ID} \${COMPONENT_PARAM_HOST}' > ./target/conf.d/default.conf < ./default.conf.https.template
  cp -r ./ssl ./target/
else
  envsubst '\${COMPONENT_PARAM_HOST}' > ./target/conf.d/default.conf < ./default.conf.template
fi
docker build \
  -t ${COMPONENT_ID}:${COMPONENT_VERSION} .
