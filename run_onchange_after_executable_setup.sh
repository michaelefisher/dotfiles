#!/bin/bash

if [[ $(which shc | echo $?) == 0 ]]; then
#  	if [[ ! -f "$HOME"/setup.sh ]]; then
#		printf '%s' "No setup.sh file found in $HOME, run chezmoi apply."
#		exit 1;
#	fi
	/opt/homebrew/bin/shc -o setup -f $HOME/setup.sh
fi

