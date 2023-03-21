#!/bin/bash

start=`date +%s`

test -f $HOME/metadata-startup-script.sh && sh -c \$HOME/metadata-startup-script.sh

if [[ -n "$USER" && "$USER" == "gitpod" ]]; then
  DOTFILES_PATH="$HOME/.dotfiles/"
fi

# Download and install Starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

# Run chezmoi
GITHUB_USERNAME=michaelefisher
CHEZMOI_DIR=/.local/share/chezmoi
rm -rf $CHEZMOI_DIR

sh -c "$(curl -fsLS https://chezmoi.io/get)"
$HOME/bin/chezmoi init --apply https://github.com/$GITHUB_USERNAME/dotfiles.git -k --config $DOTFILES_PATH/chezmoi.toml

# # Install gcloud cli
# wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-395.0.0-linux-x86_64.tar.gz
# tar -xvf google-cloud-cli*
# ./google-cloud-sdk/install.sh -q --screen-reader false

# export CLOUDSDK_CONFIG=$HOME/.gcloud
# export PATH=$HOME/google-cloud-sdk/bin:$HOME/bin:$PATH

end=`date +%s`
runtime=$((end-start))

printf 'Runtime in seconds: %s' "$runtime"

