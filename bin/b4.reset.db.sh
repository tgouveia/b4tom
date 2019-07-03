#!/bin/bash

# Test if root
if [ "$(id -u)" != "0" ]; then
	echo "   *** This script neeeds root privileges. Exiting..."
	exit 1
fi


# Usage
function help_and_exit() {
	echo "   *** Usage: $0 <OPTIONS>"
	echo ""
	echo "   Options:"
	echo ""
	echo "   --help             Exibe esta mensagem e sai do script"
	echo "   --boca=bocafolder  Pede para digitar o diretório onde está o boca"
	echo ""	
	exit 0
}


# Number of Parameters
[ "$#" -ge "2" ] && help_and_exit


# Asking for help ?
for i in $*; do
	[ "$i" == "--help" ] && help_and_exit
	[ "$i" == "-h" ] && help_and_exit
done


# Parsing the parameter (which is in the form --param=argument)
param=""
arg=""
if [ "$#" -eq 1 ]; then
	a0="$(echo ${1} | sed -r 's/^-*//' | tr '=' ' ')"
	read param arg <<< "${a0}"
	opt="$a1"
	
	[ ! -d "$arg" ] && echo "   *** ERRO: '$arg' is not a directory" && exit 1	
	[ "$param" != "boca" ] && echo "   *** ERRO: '$param' is not a valid parameter" && help_and_exit
	[ ! -f "${arg}/src/private/createdb.php" ] && echo "   *** ERRO: Can't find autojudge file in '$arg/src/private/createdb.php'" && exit 1
	
	boca="$arg"
fi


# Testing common options
if [ "$boca" == "" ]; then
	for arg in "/var/www/boca" "/var/www/html/boca" "/boca"; do
		if [ -f "${arg}/src/private/createdb.php" ]; then
			echo "   *** Boca found in '${arg}'"
			echo "   *** Running 'php ${arg}/src/private/createdb.php'"
			echo "   (Wanna run other boca? use the option --boca=bocadir)"
			boca="$arg"
			break
		fi
	done
fi


# Reading the parameter from command line
if [ "$boca" == "" ]; then
	read -e -p "   Please enter de base boca directory: " arg

	[ ! -d "$arg" ] && echo "   *** ERRO: '$arg' is not a directory" && exit 1
	[ ! -f "${arg}/src/private/createdb.php" ] && echo "   *** ERRO: Can't find autojudge file in '$arg/src/private/createdb.php'" && exit 1

	boca="$arg"
fi


# Asking for password changing
read -p "   *** Do you want to change the password for user system [y/n]? " response
if [ "${response}" == "y" -o "${response}" == "Y" ]; then
	read -p "   *** Please enter the new pass: " new_pass

	mkdir ${boca}/src/private/backup &> /dev/null
	
	cp ${boca}/src/private/conf.php ${boca}/src/private/backup/conf.php.$(date +%Y.%m.%d.%H.%M.%S)
	
	sed -i -r 's/\$conf\["basepass"\]=".*";/$conf["basepass"]="'${new_pass}'";/' ${boca}/src/private/conf.php
	
fi

# Running createdb.php
cd ${boca}/src/private
php createdb.php

