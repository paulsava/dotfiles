# ===== History =====
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

# zoxide (better cd)
eval "$(zoxide init zsh)"
alias cd="z"

# ===== fzf (fuzzy finder) =====
# Defaults: no preview globally; add preview only for Ctrl-T (file picker)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export FZF_CTRL_R_OPTS="--no-preview --preview-window=hidden"

# Load upstream fzf integration (defines fzf-history-widget, etc.)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- Fallback: if the upstream history widget didn't load, define our own ---
if ! zle -l | grep -qx 'fzf-history-widget'; then
  _fzf_hist_impl() {
    local picker selected
    if [[ -n "$TMUX" ]] && command -v fzf-tmux >/dev/null; then
      picker=(fzf-tmux -d 40%)
    else
      picker=(fzf --height 40% --layout=reverse --border)
    fi
    selected=$(
      fc -rl 1 | sed 's/^[[:space:]]*[0-9]\+[[:space:]]*//' \
      | "${picker[@]}" --no-preview --preview-window=hidden --query="$LBUFFER"
    )
    if [[ -n "$selected" ]]; then
      LBUFFER="$selected"
      zle end-of-line
    fi
  }
  fzf-history-widget() { _fzf_hist_impl; }
  zle -N fzf-history-widget
fi

# Prefix-aware Up-arrow history search using fzf
fzf-history-widget-up() {
  if [[ -n "$LBUFFER" ]]; then
    zle fzf-history-widget
  else
    zle up-line-or-history
  fi
}
zle -N fzf-history-widget-up

# ===== Keymaps (nvim vibes) =====
bindkey -v
export KEYTIMEOUT=1

# Bind Up using terminfo so it works inside/outside tmux (vi insert & command)
zmodload zsh/terminfo 2>/dev/null || true
if [[ -n ${terminfo[kcuu1]} ]]; then
  bindkey -M viins "${terminfo[kcuu1]}" fzf-history-widget-up
  bindkey -M vicmd "${terminfo[kcuu1]}" fzf-history-widget-up
else
  # fallbacks if terminfo missing
  bindkey -M viins '^[[A'  fzf-history-widget-up
  bindkey -M viins '^[OA'  fzf-history-widget-up
  bindkey -M vicmd '^[[A'  fzf-history-widget-up
  bindkey -M vicmd '^[OA'  fzf-history-widget-up
fi

# thefuck
eval "$(thefuck --alias)"

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

# ===== Git aliases =====
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate"

# ===== Paths (safe no-ops in container) =====
export PATH="$PATH:/Users/pau94516/.lmstudio/bin"
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
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Prompt
eval "$(starship init zsh)"

