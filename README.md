# dotfiles

This configuration is made to work with WSL2.

## Ubuntu Postinstall

```bash
# Install utilities
sudo apt update && \
  sudo apt install -y \
  tree \
  tldr \
  unzip \
  zsh

# Set XDG variables and other init stuff
source <(curl -fsSL https://raw.githubusercontent.com/jhonatanmacazana/dotfiles/master/.config/shell/init.sh)

# Get FNM for node
curl -fsSL https://fnm.vercel.app/install | bash -s --install-dir $XDG_CONFIG_HOME/fnm

# Get go
mkdir -p $HOME/downloads && cd $HOME/downloads
wget https://go.dev/dl/go1.18.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz

# Setup zsh as the default shell
chsh -s $(which zsh)

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install pure
mkdir -p "$XDG_CONFIG_HOME/zsh"
git clone https://github.com/sindresorhus/pure.git "$XDG_CONFIG_HOME/zsh/pure"

```

## Setup dotfiles

```bash
# Make sure you have the right dir
mkdir -p $HOME/github

# Clone with SSH
git clone --bare https://github.com/jhonatanmacazana/dotfiles $HOME/github/dotfiles

# Avoid showing untracked files
dotfiles config --local status.showUntrackedFiles no

# Get actual dotfiles
dotfiles checkout
```
