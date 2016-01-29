Docker file to setup some PHP 5.6 development image.

This primarily extends the Dockerfile from Dan Pupius that can be found on
https://medium.com/dev-tricks/apache-and-php-on-docker-44faef716150
and adds some nifty here and there.

The PHP setup is including well-known PHP development tools
as pear, composer, phpunit, PHP Codesniffer, Copy/Paste Detector,
pdepend, PHP Mess Detector as well as common PHP libraries
php5-cli, php5-mysql, php5-gd, php5-mongo.

Apache 2 is within.

Some vagrant-style convenient scripts are included:
* up.sh
* ssh.sh
* halt.sh
* init.sh
* build.sh

It deploys an SSH key to the docker and starts Apache and SSH on container
startup.

Hint: There is no database included.

The intended use is to develop PHP on one's own host machine and deploy it
to the configurable directory which is then mirrored to /var/www/site/public in
the container.

