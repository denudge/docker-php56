#!/bin/bash

source ./config.sh

docker stop ${MACHINE}
docker rm ${MACHINE}

