#!/usr/bin/env bash

# go
export PATH=$PATH:/usr/local/go/bin

# fnm
export PATH=$PATH:$XDG_CONFIG_HOME/fnm
eval "`fnm env`"

# rust
export PATH=$PATH:$HOME/.cargo/bin
#source "$HOME/.cargo.env"

## pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"
#eval "$(pyenv init -)"

# pdm 
if [ -n "$PYTHONPATH" ]; then
    export PYTHONPATH='/home/jmacazana/.local/share/pdm/venv/lib/python3.9/site-packages/pdm/pep582':$PYTHONPATH
else
    export PYTHONPATH='/home/jmacazana/.local/share/pdm/venv/lib/python3.9/site-packages/pdm/pep582'
fi

