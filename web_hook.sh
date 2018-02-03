#!/bin/bash

. /repo.cnf

repo="${LGV_REPO}"
branch="${LGV_BRANCH}"

directory="/var/www/html/app"

if [ "$repo" != "" ] && [ "$branch" != "" ]; then


	if [ -d "$directory" ]; then
  
  		rm -rf "$directory"
	fi

	mkdir "$directory"
	cd "$directory"
	git clone -b "$branch" "$repo" .

	echo -e "Updated..!"


else
	echo -e "Viables not set"

fi
