# dotfiles

This configuration is made to work with WSL2.

## Setup

```bash
# Clone with SSH (if configured)
git clone git@github.com:jhonatanmacazana/dotfiles.git

# Or clone with HTTPS and then change remotes (git remote origin set-url git@github.com:jhonatanmacazana/dotfiles.git)
git clone https://github.com/jhonatanmacazana/dotfiles
```

## Postinstall

```bash
# Install utilities
sudo apt update && \
  sudo apt install -y \
  tree \
  tldr \
  zsh

# Set XDG variables and other init stuff

```bash
curl https://raw.githubusercontent.com/jhonatanmacazana/dotfiles/master/.config/shell/init.sh | bash
```

# Get NVM for node

```bash
curl https://raw.githubusercontent.com/jhonatanmacazana/dotfiles/master/.config/shell/init.sh | bash
```

# Get golang

```
