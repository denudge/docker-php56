#!/bin/bash

source ./config.sh

source ./halt.sh

docker run -d --name ${MACHINE} -p 80:80 -v ${WEBDIR}:/var/www/site/public -it ${MACHINE} /bin/bash

sleep 1
docker exec ${MACHINE} /etc/init.d/apache2 start
docker exec ${MACHINE} /etc/init.d/ssh start

