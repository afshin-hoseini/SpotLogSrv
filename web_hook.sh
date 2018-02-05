#!/bin/bash

#Reloads system variables
. /repo.cnf

repo="${LGV_REPO}"
branch="${LGV_BRANCH}"

directory="/var/www/html/app"

if [ "$repo" != "bind" ]; then


	if [ -d "$directory" ]; then
  
  		rm -rf "$directory"
	fi

	mkdir "$directory"
	cd "$directory"

    echo -e "Cloning repo\n\n"
	git clone -b "$branch" "$repo" .

	echo -e "Updated"


else
	[ "$repo" != "bind" ] && echo -e "App is mounted." || echo -e "Variables are not set."

fi
