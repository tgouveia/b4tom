#!/bin/bash

# Usage
function help_and_exit() {
	echo "   *** Usage: $0 <OPTIONS>"
	echo ""
	echo "   Options:"
	echo ""
	echo "   --help             Exibe esta mensagem e sai do script"
	echo "   --file=users_file  Gera uma nova senha para todos os usuários"
	echo ""	
	exit 0
}


# Number of Parameters
[ "$#" -ne "1" ] && help_and_exit


# Asking for help ?
for i in $*; do
	[ "$i" == "--help" ] && help_and_exit
	[ "$i" == "-h" ] && help_and_exit
done


# Parsing the parameter (which is in the form --param=argument)
param=""
arg=""

a0="$(echo ${1} | sed -r 's/^-*//' | tr '=' ' ')"
read param arg <<< "${a0}"

# Testing the parameter
[ "$param" != "file" ] && echo "   *** ERRO: '$param' is not a valid parameter" && help_and_exit
[ ! -f "$arg" ] && echo "   *** ERRO: '$arg' is not a regular file" && exit 1

infile="$arg"


# Switching the old password by a new one
while read line; do
	if grep -E '^userpassword=.*' <<< "$line" &> /dev/null; then
		pss=$(cat /dev/urandom | tr -dc 'A-NP-Z1-9' | fold -w6 | head -1)
		echo "userpassword=${pss}"
	else
		echo $line
	fi 
	
done < "$infile"


