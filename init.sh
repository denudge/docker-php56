#!/bin/bash

source ./config.sh

docker exec ${MACHINE} /etc/init.d/apache2 start
docker exec ${MACHINE} /etc/init.d/ssh start
