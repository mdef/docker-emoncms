FROM ubuntu
MAINTAINER https://github.com/mdef


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN \
  apt-get install -y mysql-server mysql-client php5-fpm php5-mysql php5-curl php-pear php5-dev php5-mcrypt php5-json git-core redis-server build-essential ufw ntp nginx supervisor
RUN sudo pear channel-discover pear.swiftmailer.org &&\
sudo pecl install channel://pecl.php.net/dio-0.0.6 redis swift/swift &&\
#sudo sh -c 'echo "extension=dio.so" > /etc/php5/apache2/conf.d/20-dio.ini' &&\
sudo sh -c 'echo "extension=dio.so" > /etc/php5/cli/conf.d/20-dio.ini' &&\
#sudo sh -c 'echo "extension=redis.so" > /etc/php5/apache2/conf.d/20-redis.ini' &&\
sudo sh -c 'echo "extension=redis.so" > /etc/php5/cli/conf.d/20-redis.ini'

RUN /etc/init.d/mysql start && \
echo "create database emoncms;" | mysql -u root && \
echo "CREATE USER 'emoncms'@'localhost' IDENTIFIED BY 'emoncms';" | mysql -u root && \
echo "GRANT ALL ON emoncms.* TO 'emoncms'@'localhost';" | mysql -u root && \
echo "flush privileges;" | mysql -u root


RUN mkdir /var/lib/{phpfiwa,phpfina,phptimeseries}
RUN chown www-data:root /var/lib/{phpfiwa,phpfina,phptimeseries}

RUN mkdir -p /var/www/emoncms
RUN chown www-data:www-data /var/www/emoncms
RUN git clone https://github.com/emoncms/emoncms.git /var/www/emoncms
RUN git clone https://github.com/emoncms/app.git /var/www/emoncms/Modules/app

RUN cp /var/www/emoncms/default.settings.php /var/www/emoncms/settings.php
RUN sed -i 's/$username = "_DB_USER_";/$username = "emoncms";/g' /var/www/emoncms/settings.php
RUN sed -i 's/$password = "_DB_PASSWORD_";/$password = "emoncms";/g' /var/www/emoncms/settings.php

RUN mkdir /var/lib/php5/sessions && chown www-data:www-data /var/lib/php5/sessions
RUN sed -i 's/;session.save_path = "\/var\/lib\/php5"/session.save_path = "\/var\/lib\/php5\/sessions"/g' /etc/php5/fpm/php.ini


ADD ./emoncms.conf /etc/nginx/conf.d/emoncms.conf


VOLUME ["/var/lib/mysql"]
VOLUME ["/var/www/emoncms"]
VOLUME ["/var/lib/phpfiwa"]
VOLUME ["/var/lib/phpfina"]
VOLUME ["/var/lib/phptimeseries"]

