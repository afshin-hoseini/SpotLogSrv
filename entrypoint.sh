#!/bin/bash

repo="${LGV_REPO:-bind}"
branch="${LGV_BRANCH:-bind}"
dbRootPass="${LGV_DB_ROOT_PASS:-root}"
currentDbRootPass="${LGV_DB_ROOT_CUR_PASS:-root}"
adminUserName="${LGV_ADMIN_USER:-root}"
adminPass="${LGV_ADMIN_PASS:-root}"

#Removes the repo config file if exists
[ -f /repo.cnf ] && rm /repo.cnf

#Saves admin user information
echo "LGV_ADMIN_USER=${adminUserName}" >> /repo.cnf
echo "LGV_ADMIN_PASS=${adminPass}" >> /repo.cnf

#Saves the code repository information
echo "LGV_REPO=${repo}" >> /repo.cnf
echo "LGV_BRANCH=${branch}" >> /repo.cnf

#Clones the project from git
/bin/bash /var/www/html/web_hook.sh

#Starts up the the services
echo -e "----> Starting up services\n"
service mysql start
service apache2 start

#Saves the database root user's password
echo "LGV_DB_ROOT_PASS=${dbRootPass}" >> /repo.cnf

#Changes the database password if requested. This must get done after that mysql service is started.
if [ "$dbRootPass" != "" ]; then
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$dbRootPass';" | mysql -u root --password="${currentDbRootPass}"
fi

#Changes the ownership to www-data
chown -R www-data /var/www/html/app
chown www-data /var/www/html/web_hook.sh

if [ -d /var/www/data ]; then
    chown -R www-data /var/www/data
fi

echo -e "**** SERVER STARTED SUCCESSFULLY ****"

tail -f /dev/null
