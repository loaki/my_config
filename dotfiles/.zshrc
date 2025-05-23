export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="catppuccin"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# aliases
alias python="python3"
alias dc="docker compose"
alias tetris="tetriscurses"
preview_cmd="cat {}"
if command -v bat > /dev/null; then
  alias cat="bat"
  preview_cmd="bat --style=numbers --color=always --line-range :500 {}"
elif command -v batcat > /dev/null; then
  alias cat="batcat"
  preview_cmd="batcat --style=numbers --color=always --line-range :500 {}"
fi
if command -v zoxide > /dev/null; then
  alias cd="z"
fi
if command -v lsd > /dev/null; then
  alias ls="lsd --size short --date relative"
fi

# load modules
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors
autoload -Uz tetriscurses

# history setup
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=$HOME/.zsh_history
HISTCONTROL=ignoreboth

# autocompletion using arrow keys (based on history)
bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# never beep
setopt NO_BEEP

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"

export FZF_CTRL_T_OPTS="--preview='$preview_cmd'"
export FZF_CTRL_R_OPTS="--preview-window down:wrap --preview='echo {}'"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
--color=selected-bg:#494d64 \
--color=border:#363a4f,label:#cad3f5"

# Created by `pipx` on 2025-05-23 13:18:49
export PATH="$PATH:/home/loaki/.local/bin"
