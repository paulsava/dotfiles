# ===== History =====
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

alias dotgit='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ===== Modern CLI Tools =====
alias ls="eza --icons=always --group-directories-first"
alias ll="eza -l --icons=always --group-directories-first"
alias la="eza -la --icons=always --group-directories-first"
alias lt="eza --tree --level=2 --icons=always"
alias l="eza -1 --icons=always"

alias cat="bat --style=auto"   # bat
alias find="fd"                 # fd
alias grep="rg"                 # ripgrep

# zoxide (better cd)
eval "$(zoxide init zsh)"
alias cd="z"

# ===== fzf (fuzzy finder) =====
# Global defaults: no preview for generic pickers
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
# Nice preview only for file picker; never for history
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
export FZF_CTRL_R_OPTS="--no-preview --preview-window=hidden"

# Load fzf integration from whichever install exists (works on macOS Homebrew & Linux)
for f in \
  "$HOME/.fzf.zsh" \
  "$(command -v brew >/dev/null 2>&1 && brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh" \
  /usr/share/fzf/key-bindings.zsh \
  /usr/share/doc/fzf/examples/key-bindings.zsh
do
  [ -f "$f" ] && source "$f" && break
done
for f in \
  "$(command -v brew >/dev/null 2>&1 && brew --prefix 2>/dev/null)/opt/fzf/shell/completion.zsh" \
  /usr/share/fzf/completion.zsh \
  /usr/share/doc/fzf/examples/completion.zsh
do
  [ -f "$f" ] && source "$f" && break
done

# Fallback: if upstream didn't define the history widget, provide our own
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

# Bind Up across environments:
# - use terminfo sequence if available
# - also bind common CSI variants so it works in Ghostty/iTerm/Alacritty and inside tmux
zmodload zsh/terminfo 2>/dev/null || true
typeset -a __UP_SEQS
[[ -n ${terminfo[kcuu1]} ]] && __UP_SEQS+=("${terminfo[kcuu1]}")
__UP_SEQS+=('^[[A' '^[OA')
for seq in "${__UP_SEQS[@]}"; do
  bindkey -M viins "$seq" fzf-history-widget-up
  bindkey -M vicmd "$seq" fzf-history-widget-up
done

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

# ===== Paths (safe on macOS; no-ops in container) =====
export PATH="$PATH:/Users/pau94516/.lmstudio/bin"
[ -f '/Users/pau94516/google-cloud-sdk/path.zsh.inc' ] && . '/Users/pau94516/google-cloud-sdk/path.zsh.inc'
[ -f '/Users/pau94516/google-cloud-sdk/completion.zsh.inc' ] && . '/Users/pau94516/google-cloud-sdk/completion.zsh.inc'

# Local bin
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# ===== Completions =====
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Prompt
eval "$(starship init zsh)"

