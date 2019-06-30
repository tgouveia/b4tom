#!/bin/bash

# Stores the directory from which the script was called
olddir=$(pwd)

# Associative array with the options
declare -A opt

# Deal with command line options
for arg in $*; do
	if [ "$arg" == "--help" ]; then
		echo "   *** Usage: $0 [OPTIONS]"
		echo "   *** OPTIONS:"
		echo "             --name=problem           One word to name of the problem"
		echo "             --descfile=Problem.pdf   The file describing the problem"
		echo "             --infolder=./input       Folder with the testcases"
		echo "             --outfolder=./output     Folder with th solutions"
		echo "             --timelimit=4            Time limit in seconds"
		exit 0
	fi

	a0="$(echo ${arg} | sed -r 's/^-*//' | tr '=' ' ')"
	read a1 a2 <<< "${a0}"
	opt[$a1]="$a2"
done


# Filling the array opt with the options
function askfor(){
	varname=$1
	default=$2
	text=$3

	[ "${opt[$varname]}" != "" ] && return

	read -e -p "   $text [${default}]: " tmpvar

	opt[$varname]="$tmpvar"
	[ -z "$tmpvar" ] && opt[$varname]="$default"
}


# Reading the necessary information
askfor name "problem" "Please enter the problem short name"
askfor descfile "Problem.pdf" "Please enter the problem description file"
askfor infolder "./input" "Please enter the folder where the INPUTS are"
askfor outfolder "./output" "Please enter the folder where the OUTPUTS are"
askfor timelimit "4" "Please enter the time limit (seconds) for the problem"


# Moving to the directory where this script actualy is
true_path="$(readlink -f $0)"
cd $(dirname $true_path)

# Temporary folder for the problem
tdir=$(mktemp -d /tmp/b4.XXXXXXXXX)

# Copying (creating) the necessary files
cp -r ../assets/base_problem/* $tdir
cp ${olddir}/${opt[infolder]}/* $tdir/input/
cp ${olddir}/${opt[outfolder]}/* $tdir/output/
echo "basename=${opt[name]}" > $tdir/description/problem.info
echo "fullname=${opt[name]}" >> $tdir/description/problem.info
echo "descfile=$(basename ${opt[descfile]})" >> $tdir/description/problem.info
cp ${olddir}/${opt[descfile]} $tdir/description/

# Changing the TimeLimit
for lf in $tdir/limits/*; do
	sed -i "3c echo ${opt[timelimit]}" ${lf}
done

# Creating the zip file
cd $tdir
zip -r ${olddir}/${opt[name]}.zip * > /dev/null

# Cleaning up the garbage
rm -rf ${tdir}

# All Done
echo ""
echo " DONE"
echo " Problem ${olddir}/${opt[name]}.zip created successfully."


