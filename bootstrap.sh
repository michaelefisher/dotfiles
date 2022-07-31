#!/usr/bin/env bash

cat<<EOF > ~/.config/chezmoi/chezmoi.toml
[data]
email = "fisher@techallies.org"
python.version = "3.9.1"
sshAgentContainer.location = "2BUA8C4S2C.com.1password"
[git]
autoCommit = true
autoPush = true
[editor]
command = "vim"
EOF

GITHUB_USERNAME=michaelefisher
sh -c "$(curl -fsLS https://chezmoi.io/get)" -- init --one-shot -k --apply $GITHUB_USERNAME
