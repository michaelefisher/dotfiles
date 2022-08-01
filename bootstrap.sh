#!/usr/bin/env bash

# This script only runs in the Google Cloud Shell environment

curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
 sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
 sudo tee /etc/apt/sources.list.d/1password.list

mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
 sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
 sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

apt-get update
apt-get -y install \
  gcc \
  cmake \
  python3.9-dev \
  python3-pip \
  libssl-dev \
  make \
  libutempter-dev \
  zlib1g-dev \
  1password-cli \
  zsh

# Download and install Starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

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

export CLOUDSDK_CONFIG=$HOME/.gcloud

