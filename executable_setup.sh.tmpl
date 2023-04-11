#!/bin/bash

start=`date +%s`
{{ if eq .chezmoi.os "linux" }}
test -f "$HOME"/metadata-startup-script.sh && sh -c "$HOME"/metadata-startup-script.sh
{{ end }}

DOTFILES_PATH="$HOME"
if [[ -n "$USER" && "$USER" == "gitpod" ]]; then
  DOTFILES_PATH="${HOME}/.dotfiles/"
fi


# Install brew.sh if needed (on linux and macOS)
if [[ ! $(brew -v | echo $?) -eq 0 ]]; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Download and install Starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

# Run chezmoi
GITHUB_USERNAME=michaelefisher
CHEZMOI_DIR=/.local/share/chezmoi
rm -rf "$CHEZMOI_DIR"

sh -c "$(curl -fsLS https://chezmoi.io/get)"
"$HOME"/bin/chezmoi init --apply https://github.com/"$GITHUB_USERNAME"/dotfiles.git -k --config "$DOTFILES_PATH"/chezmoi.toml

# Brew bundle
if [[ $(brew -v | echo $?) -eq 0]]; then
  brew bundle -f
fi

end=`date +%s`
runtime=$((end-start))

printf 'Runtime in seconds: %s' "$runtime"

