FROM mobingi/ubuntu-apache2-php7:7.2


# ------ Mariadb installation --------

RUN {\

		echo mariadb-server-10.2 mysql-server/root_password password 'root'; \
		echo mariadb-server-10.2 mysql-server/root_password_again password 'root'; \
	} | debconf-set-selections &&\
	apt-get install software-properties-common &&\
	apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 &&\
	add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mariadb.mirrors.ovh.net/MariaDB/repo/10.2/ubuntu xenial main' &&\
	apt-get update &&\
	apt-get install -y mariadb-server

RUN mysql --version

# -------- PhpMyAdmin installation ---------

RUN {\
		echo phpmyadmin phpmyadmin/dbconfig-install boolean true; \
		echo phpmyadmin phpmyadmin/app-password-confirm password 'root'; \
		echo phpmyadmin phpmyadmin/mysql/admin-pass password 'root'; \
		echo phpmyadmin phpmyadmin/mysql/app-pass password 'root'; \
		echo phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2; \
	} | debconf-set-selections &&\
	apt-get install wget &&\
	cd /var/www/html &&\
	wget https://files.phpmyadmin.net/phpMyAdmin/4.7.7/phpMyAdmin-4.7.7-english.tar.gz &&\
	tar xvzf phpMyAdmin-4.7.7-english.tar.gz &&\
	mv phpMyAdmin-4.7.7-english phpmyadmin &&\
	rm phpMyAdmin-4.7.7-english.tar.gz

# -------- Git installation ---------------

RUN apt-get install -y git

COPY entrypoint.sh /bin/entrypoint.sh
COPY web_hook.sh /var/www/html/web_hook.sh

RUN chmod +x /bin/entrypoint.sh
RUN chmod +x /var/www/html/web_hook.sh

CMD ["/bin/entrypoint.sh"]

