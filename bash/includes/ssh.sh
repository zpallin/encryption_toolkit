#!/bin/bash

#
# SSH.sh 
#   This script will add an ssh configuration that allows ssh keys to be added to the keychain
#   It looks for the existing header and footer. If it finds these, then it will update config
#   between them, otherwise it adds the config at the end of the ssh config file.
#

SSHTOOLKITHEADER="#zpallin-toolkit-ssh-head"
SSHTOOLKITFOOTER="#zpallin-toolkit-ssh-foot"

function insert-ssh-config() {
	INSERTCONF='Host *\n\tIgnoreUnknown yes\n\tAddKeysToAgent yes\n\tIdentityFile ~\/.ssh\/id_rsa'

	sed -i -n "/#zpallin.toolkit.ssh.head/{p;:a;N;/#zpallin.toolkit.ssh.foot/!ba;s/.*\n/$INSERTCONF\n/};p" ~/.ssh/config
}

function manage-ssh-config() {
	C=~/.ssh/config
	H=$SSHTOOLKITHEADER
	F=$SSHTOOLKITFOOTER

	FH=$(grep -nr $H ~/.ssh/config)
	FF=$(grep -nr $F ~/.ssh/config)

#	if [ -n "$FH" ] && [ -n "$FF" ]; then
		#echo only insert config
#	fi

	if [ -n "$FH" ] && [ -z "$FF" ]; then
		#echo add footer, then insert config
		sed -i "s/$H/$H\n$F/" $C
	fi

	if [ -z "$FH" ] && [ -n "$FF" ]; then
		#echo add header, then insert config
		sed -i "s/$F/$H\n$F/" $C
	fi

	if [ -z "$FH" ] && [ -z "$FF" ]; then
		#echo add both header and footer, then insert config
		printf $H\\n$F >> $C
		printf $H\\n$F
	fi
	
	insert-ssh-config
}

manage-ssh-config
#
#zpallin-toolkit-ssh-head
#Host *
#  IgnoreUnknown UseKeychain
#  UseKeychain yes
#  AddKeysToAgent yes
#  IdentityFile ~/.ssh/id_rsa
#zpallin-toolkit-ssh-foot
#
