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
	echo ""	
	exit 0
}

# Number of Parameters
[ "$#" -ne "0" ] && help_and_exit


# Asking for help ?
for i in $*; do
	[ "$i" == "--help" ] && help_and_exit
	[ "$i" == "-h" ] && help_and_exit
done

# Stores the directory from which the script was called
olddir=$(pwd)

# Moving to the directory where this script actualy is
true_path="$(readlink -f $0)"
cd $(dirname $true_path)


# Creating the links
b4dir=$(pwd)

for i in *; do
	echo "   *** Linking '${b4dir}/${i}' -> /bin/${i}"
	ln -s ${b4dir}/${i} /bin/${i}
done

echo    "*** All Done!"

