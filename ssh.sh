#!/bin/bash

source ./config.sh

ADDRESS=`docker inspect ${MACHINE} | grep IPAddress | tail -n 1 | cut -d'"' -f 4`

ssh root@${ADDRESS}

