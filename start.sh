#!/bin/bash

MACHINE=php56
WEBDIR=`pwd`

docker stop ${MACHINE}
docker rm ${MACHINE}
docker run -d --name ${MACHINE} -p 80:80 -v ${WEBDIR}:/var/www/site -it ${MACHINE} /bin/bash
sleep 1
docker exec ${MACHINE} /etc/init.d/apache2 start
docker exec ${MACHINE} /etc/init.d/ssh start

