**Docker image creation for [Emoncms.org](http://emoncms.org/ "")**

Emoncms is running on ubuntu with nginx, mysql,php5-fpm

```bash
git clone https://github.com/mdef/docker-emoncms
cd docker-emoncms
docker build -t yourname/emoncms .
```


**Export data from image**

This is needed only once, to export virgin data created during build stage.

/home/core/git/emoncms - directory on host and should be present.

```bash
docker run --rm -v /home/core/git/emoncms:/host yourname/emoncms cp -rp {/var/www/emoncms,/var/lib/mysql,/var/lib/phpfina,/var/lib/phpfiwa,/var/lib/phptimeseries} /host/
```

In directory /home/core/git/emoncms you will have dynamic files created by emoncms container, but on your host. This is needed for persistence. 

list of exported directories from container to host:

    /var/www/emoncms 
    /var/lib/mysql
    /var/lib/phpfiwa
    /var/lib/phpfina
    /var/lib/phptimeseries



**Run container with data stored on host**

Run for testing
```bash
docker run -it -p 80:80 \
-v /home/core/git/emoncms/emoncms:/var/www/emoncms \ 
-v /home/core/git/emoncms/mysql:/var/lib/mysql \
-v /home/core/git/emoncms/phpfiwa:/var/lib/phpfiwa \
-v /home/core/git/emoncms/phpfina:/var/lib/phpfina \
-v /home/core/git/emoncms/phptimeseries:/var/lib/phptimeseries \
-v /home/core/git/emoncms/sessions:/var/lib/php5/sessions \
-v /home/core/git/emoncms/supervisor:/etc/supervisor/conf.d \
yourname/emoncms /bin/bash 
```

Run in production
```bash
/usr/bin/docker run -p 80:80 -v /home/core/git/emoncms/emoncms:/var/www/emoncms -v /home/core/git/emoncms/mysql:/var/lib/mysql -v /home/core/git/emoncms/phpfiwa:/var/lib/phpfiwa -v /home/core/git/emoncms/phpfina:/var/lib/phpfina -v /home/core/git/emoncms/phptimeseries:/var/lib/phptimeseries -v /home/core/git/emoncms/sessions:/var/lib/php5/sessions -v /home/core/git/emoncms/supervisor:/etc/supervisor/conf.d yourname/emoncms /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
```

