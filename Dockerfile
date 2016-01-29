FROM ubuntu:wily

# System installierbar machen
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common wget

# System benutzbar machen
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git-core vim mc
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install rsync openssh-server openssh-client openntpd
RUN sed -i "s/DAEMON_OPTS=\"-f \/etc\/openntpd\/ntpd.conf\"/DAEMON_OPTS=\"-f \/etc\/openntpd\/ntpd.conf -s\"/" /etc/default/openntpd
RUN mkdir -p /root/.ssh
RUN chmod 700 /root/.ssh
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

# Install Apache, PHP, and supplimentary programs. curl and lynx-cur are for
# debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-php5 php5-mysql php5-mongo php5-cli php5-dev php5-gd php-pear php-apc php5-curl curl lynx-cur ant

# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# Zeitzone richtig setzen
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN sed -i "s/;date.timezone =/date.timezone = \"Europe\/Berlin\"/" /etc/php5/apache2/php.ini
RUN sed -i "s/;date.timezone =/date.timezone = \"Europe\/Berlin\"/" /etc/php5/cli/php.ini

# Install PHPUnit
RUN cd /tmp; wget https://phar.phpunit.de/phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit

# Install composer
RUN cd /tmp; wget https://getcomposer.org/download/1.0.0-alpha11/composer.phar && \
    chmod +x composer.phar && \
    mv composer.phar /usr/local/bin/composer

# Install Copy/PasteDetector
RUN cd /tmp; wget https://phar.phpunit.de/phpcpd.phar && \
    chmod +x phpcpd.phar && \
    mv phpcpd.phar /usr/local/bin/phpcpd

# Install other php-tools
RUN pear channel-update pear.php.net
RUN pear install PHP_CodeSniffer-2.5.1
RUN pear channel-discover pear.phpmd.org
RUN pear channel-discover pear.pdepend.org
RUN pear install --alldeps phpmd/PHP_PMD
RUN pear channel-discover pear.survivethedeepend.com
RUN pear channel-discover hamcrest.googlecode.com/svn/pear
RUN pear install --alldeps deepend/Mockery


# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

# Update the default apache site with the config we created.
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

CMD ["bash"]

