#!/bin/bash

# Usage
function help_and_exit() {
	echo "   *** Usage: $0 <OPTIONS>"
	echo ""
	echo "   Options:"
	echo ""
	echo "   --help            Exibe esta mensagem e sai do script"
	echo "   --prompt          Pede para digitar os nomes e descrições dos usuários"
	echo "   --csv=in_file     Nomes e descrições no arquivo infile, um por linha, separados"
	echo "                     por vírgula. Ex.: user1,IFPB-Xico Silva"
	echo "   --tab=in_file     Nomes e descrições no arquivo infile, um por linha, separados"
	echo "                     por tab. Ex.: user1	IFPB-Xico Silva"
	echo "   --space=in_file   Nomes e descrições no arquivo infile, um por linha, separados"
	echo "                     por espaço. Ex.: user1 IFPB-Xico Silva"
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

# Parsing the parameter (which is in the form --param=argument
opt=""

a0="$(echo ${1} | sed -r 's/^-*//' | tr '=' ' ')"
read param arg <<< "${a0}"
opt="$a1"


# Verifying if the parameter is valid
arg_ok="NO"
for i in "prompt" "csv" "tab" "space"; do
	[ "$param" == "$i" ] && arg_ok=="OK"
done

[ "$arg_ok" == "NO" ] && echo "   *** Argumento não reconhecido: $1" && help_and_exit


# Parameters OK $param and $arg ------------------------------------------------------

# --prompt
if [ "$param" == "prompt" ]; then
	echo "   *** Entering prompt mode."
	read -e -p "       Enter the output filename: " outfile

	start_id=3000

	# outfile already exists
	if [ -f "$outfile" ]; then
		echo "       File already exists... appending new users."

		l1=$(head -1 ${outfile} | tr -d ' ')
		if [ "$l1" != "[user]" ]; then
			echo "       ERRO: primeira linha do arquivo deve ser [user]. Saindo..."
			exit 1
		fi
		
		a0=$(cat $outfile | grep -E '^usernumber=[0-9]*$' | tail -1)
		[ "$a0" != "" ] && start_id=$(cut -d '=' -f2 <<< "$a0")
	fi
	
	# New File
	if [ ! -e "$outfile" ]; then
		echo "       File does not exist... Creating."
		echo '[user]' > "${outfile}"
	fi

	while true; do
		start_id=$(( $start_id + 2 ))
		
		echo "--"
		read -p "       Enter the username (quit to finish): " username

		[ "${username}" == "" ] && echo "Saindo..." && exit 0
		[ "${username}" == "quit" ] && echo "Saindo..." && exit 0

		read -p "       Enter the description: " userdesc
		
		pss=$(cat /dev/urandom | tr -dc 'A-NP-Z1-9' | fold -w6 | head -1)
				
		echo "" >> $outfile
		echo "usernumber=$start_id" >> $outfile
		echo "usersitenumber=1" >> $outfile
		echo "username=${username}" >> $outfile
		echo "userenabled=t" >> $outfile
		echo "userfullname=${userdesc}" >> $outfile
		echo "userdesc=${userdesc}" >> $outfile
		echo "userpassword=${pss}" >> $outfile
		
	done

fi

# --csv or --tab or --space
[ ! -f "${arg}" ] && echo "   ERRO: File '$arg' does not exists... exiting" && exit 1
[ "${param}" == "space" ] && cp ${arg} /tmp/b4.users.tmp
[ "${param}" == "csv" ] && cat ${arg} |  sed 's/,/ /' > /tmp/b4.users.tmp
[ "${param}" == "tab" ] && cat ${arg} |  sed 's/\t/ /' > /tmp/b4.users.tmp

start_id=3000
echo '[user]'
while read username userdesc; do
		start_id=$(( $start_id + 2 ))
		pss=$(cat /dev/urandom | tr -dc 'A-NP-Z1-9' | fold -w6 | head -1)
				
		echo "usernumber=$start_id"
		echo "usersitenumber=1"
		echo "username=${username}"
		echo "userenabled=t"
		echo "userfullname=${userdesc}"
		echo "userdesc=${userdesc}"
		echo "userpassword=${pss}"
		echo ""
		
done < "/tmp/b4.users.tmp"

rm /tmp/b4.users.tmp

