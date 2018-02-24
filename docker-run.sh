#!/bin/bash -e
export STATIC_ANGULAR_HOSTNAME=0.0.0.0
export STATIC_ANGULAR_PORT=80
export STATIC_ANGULAR_PORTS=443
docker build --build-arg STATIC_ANGULAR_HOSTNAME=$STATIC_ANGULAR_HOSTNAME \
             --build-arg STATIC_ANGULAR_PORT=$STATIC_ANGULAR_PORT \
             --build-arg STATIC_ANGULAR_PORTS=$STATIC_ANGULAR_PORTS \
             -t tln-angular:latest .
docker run -d --rm -p $STATIC_ANGULAR_PORT:$STATIC_ANGULAR_PORT -p $STATIC_ANGULAR_PORTS:$STATIC_ANGULAR_PORTS --name tln-angular tln-angular:latest
