export PATH=$HOME/bin:/usr/local/bin:/home/jmacazana/.local/bin:$PATH

export ZSH="/home/jmacazana/.oh-my-zsh"
export VISUAL="vim"
export EDITOR="$VISUAL"
#export TERMINAL="alacritty"

#ZSH_THEME="avit"
ZSH_THEME=""

#plugins=(git z)
#plugins=(git z docker docker-compose)

plugins=(wakatime)

source $ZSH/oh-my-zsh.sh
source /etc/zsh_command_not_found

export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

export ARCHFLAGS="-arch x86_64"

for file in ~/.config/shell/{exports,aliases,functions,extra,lscolors,private}.sh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

fpath+=$HOME/.config/zsh/pure
autoload -U promptinit; promptinit
prompt pure
