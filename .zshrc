# ===== Performance - Load instant prompt =====
# Keep history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

alias dotgit='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ===== Modern CLI Tools =====

# eza (better ls)
alias ls="eza --icons=always --group-directories-first"
alias ll="eza -l --icons=always --group-directories-first"
alias la="eza -la --icons=always --group-directories-first"
alias lt="eza --tree --level=2 --icons=always"
alias l="eza -1 --icons=always"

# bat (better cat)
alias cat="bat --style=auto"

# fd (better find)
alias find="fd"

# ripgrep (better grep)
alias grep="rg"

# zoxide (better cd) - remembers your directories
eval "$(zoxide init zsh)"
alias cd="z"

# fzf (fuzzy finder)
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
alias ff="fzf --preview 'bat --color=always {}'"

eval $(thefuck --alias)

# ===== Editor =====
export EDITOR='nvim'
export VISUAL='nvim'
alias vim="nvim"
alias vi="nvim"

# ===== Better defaults =====
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias mkdir="mkdir -p"

# ===== Git aliases (keep the useful ones) =====
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# ===== Paths (keep your existing ones) =====
# LM Studio
export PATH="$PATH:/Users/pau94516/.lmstudio/bin"

# Google Cloud SDK
if [ -f '/Users/pau94516/google-cloud-sdk/path.zsh.inc' ]; then 
  . '/Users/pau94516/google-cloud-sdk/path.zsh.inc'
fi
if [ -f '/Users/pau94516/google-cloud-sdk/completion.zsh.inc' ]; then 
  . '/Users/pau94516/google-cloud-sdk/completion.zsh.inc'
fi

# Local bin
if [ -f "$HOME/.local/bin/env" ]; then
  source "$HOME/.local/bin/env"
fi

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# ===== Completions =====
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

eval "$(starship init zsh)"


export FZF_CTRL_R_OPTS="--preview-window=hidden"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fzf-history-widget-up() {
  # If the buffer is not empty, trigger fzf
  if [[ -n "$LBUFFER" ]]; then
    zle fzf-history-widget
  # Otherwise, fall back to the normal Up Arrow behavior
  else
    zle up-line-or-history
  fi
}
zle -N fzf-history-widget-up

# Bind the Up Arrow key to our new custom widget
bindkey '^[[A' fzf-history-widget-up
