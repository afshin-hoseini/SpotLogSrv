#!/bin/bash

repo="${LGV_REPO}"
branch="${LGV_BRANCH}"


if [ "$repo" != "" ] && [ "$branch" != "" ]; then

	echo "LGV_REPO=${repo}" >> /repo.cnf
	echo "LGV_BRANCH=${branch}" >> /repo.cnf



	echo -e "Startin services\n"
	service mysql start
	service apache2 start

	echo -e "Cloning repo\n\n"

	/bin/bash /var/www/html/web_hook.sh

	echo -e "**** SERVER STARTED SUCCESSFULLY ****"

	if [ "$LGV_DB_ROOT_PASS" != "" ]; then 

		echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$LGV_DB_ROOT_PASS';" | mysql -u root --password="root"
	fi

	chown -R www-data /var/www/html/app
	chown www-data /var/www/html/web_hook.sh

	tail -f /dev/null

else
	echo -e "You have to set these enviroment variables: \n\t1.\tLGV_REPO : The name of the repository. \n\t2.\tLGV_BRANCH : The name of the branch to clone."

fi