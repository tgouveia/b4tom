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
	echo "   --boca=bocafolder  Pede para digitar os nomes e descrições dos usuários"
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
	
	[ "$param" != "boca" ] && echo "   *** ERRO: '$param' is not a valid parameter" && help_and_exit
	[ ! -d "$arg" ] && echo "   *** ERRO: '$arg' is not a directory" && exit 1
	[ ! -x "${arg}/tools/autojudge.sh" ] && echo "   *** ERRO: Can't find autojudge file in '$arg/tools'" && exit 1
	
	boca="$arg"
fi


# Testing common options
if [ "$boca" == "" ]; then
	for arg in "/var/www/boca" "/var/www/html/boca" "/boca"; do
		if [ -x "${arg}/tools/autojudge.sh" ]; then
			echo "   *** Boca found in '${arg}'"
			echo "   *** Running '${arg}/tools/autojudge.sh'"
			echo "   (Wanna run other boca? use the option--boca=bocadir)"
			boca="$arg"
			break
		fi
	done
fi


# Reading the parameter from command line
if [ "$boca" == "" ]; then
	read -e -p "   Please enter de base boca directory: " arg

	[ ! -d "$arg" ] && echo "   *** ERRO: '$arg' is not a directory" && exit 1
	[ ! -x "${arg}/tools/autojudge.sh" ] && echo "   *** ERRO: Can't find autojudge file in '$arg/tools'" && exit 1

	boca="$arg"
fi

# Running Autojudge
${boca}/tools/autojudge.sh

