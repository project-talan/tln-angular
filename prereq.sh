#!/bin/bash -e
envsubst > sonar-project.properties < sonar-project.properties.template
envsubst > .env < .env.template
npm i
