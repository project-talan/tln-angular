#!/bin/bash -e
export $(cat ./.env | grep -v ^# | xargs)
rm -rf ./target || true
mkdir target
mkdir target/conf.d
if [ -d ./ssl ]
then
  envsubst '\${TLN_COMPONENT_ID} \${TLN_COMPONENT_PARAM_HOST}' > ./target/conf.d/default.conf < ./default.conf.https.template
  cp -r ./ssl ./target/
else
  envsubst '\${TLN_COMPONENT_PARAM_HOST}' > ./target/conf.d/default.conf < ./default.conf.template
fi
docker build \
  -t ${TLN_COMPONENT_ID}:${TLN_COMPONENT_VERSION} .