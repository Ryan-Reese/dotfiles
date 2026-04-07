. "$HOME/.local/bin/env"
typeset -U path

# --- History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# --- Editor ---
if [[ -n $SSH_CONNECTION ]]; then
    export VISUAL='vim'
    export EDITOR='vim'
else
    export VISUAL='nvim'
    export EDITOR='nvim'
fi

# --- Environment ---
export TMS_CONFIG_FILE="$HOME/.config/tms/config.toml"

# --- fzf (uses fd for speed) ---
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

# --- Aliases ---
alias conda-init="source $HOME/miniforge3/bin/activate"
alias brew-steep="brew update && brew upgrade && brew cleanup"

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
    colored-man-pages
    command-not-found
    fzf
    vi-mode
    conda-env
)
source "$ZSH/oh-my-zsh.sh"

# --- Zsh plugins (Homebrew) ---
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# --- API keys ---
[[ -f ~/.keys ]] && source ~/.keys
