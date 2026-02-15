. "$HOME/.local/bin/env"

# >>> set EDITOR >>>
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi
# <<< set EDITOR <<<

# >>> ssh key >>>
#eval `ssh-agent`
#ssh-add "/Users/ryreese/.ssh/main"
# <<< ssh key  <<<

# >>> add rust to path >>>
export PATH="$(brew --prefix rustup)/bin:$PATH"
# <<< add rust to path <<<
#
# >>> set tms config path >>>
export TMS_CONFIG_FILE="/Users/ryreese/.config/tms/config.toml"
# <<< set tms config path <<<
#
# >>> conda initialize >>>
function conda_init() {
    __conda_setup="$('/Users/ryreese/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/Users/ryreese/miniforge3/etc/profile.d/conda.sh" ]; then
            . "/Users/ryreese/miniforge3/etc/profile.d/conda.sh"
        else
            export PATH="/Users/ryreese/miniforge3/bin:$PATH"
        fi
    fi
    unset __conda_setup
}
# <<< conda initialize <<<

# >>> oh my zsh >>>
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
    git
    colored-man-pages
    command-not-found
    vi-mode
    conda-env
)

source $ZSH/oh-my-zsh.sh
# <<< oh my zsh <<<
