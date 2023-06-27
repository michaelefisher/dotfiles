#!/bin/bash

if [[ $(which shc | echo $?) == 0 ]]; then
#  	if [[ ! -f "$HOME"/setup.sh ]]; then
#		printf '%s' "No setup.sh file found in $HOME, run chezmoi apply."
#		exit 1;
#	fi
	shc -o setup -f $HOME/setup.sh

	# Delete source and compilation files
	test setup.sh.x.c && rm setup.sh.x.c
fi
