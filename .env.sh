#!/bin/bash -e

if [ -f './../../.env' ]; then
  echo '## Export variables from project .env file'
  export $(cat ./../../.env | grep -v ^# | xargs)
  export COMPONENT_ID="${ID}"
  export COMPONENT_VERSION=${PROJECT_VERSION}
  export COMPONENT_PARAM_HOST=${HOST}
  export COMPONENT_PARAM_LSTN=${LSTN}
  export COMPONENT_PARAM_PORT=${PORT}
  export COMPONENT_PARAM_PORTS=${PORTS}

  # project specific mappings
fi

if [ -f './.env' ]; then
  echo '## Export variables from local .env file'
  export $(cat ./.env | grep -v ^# | xargs)
fi

printenv | grep COMPONENT_ | sort
