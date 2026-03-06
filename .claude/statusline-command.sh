#!/usr/bin/env bash
# Claude Code status line — mirrors robbyrussell zsh theme
# Reads JSON from stdin, outputs a formatted ANSI status line

set -euo pipefail

# -- Colors (matching robbyrussell theme) --
BOLD_CYAN='\033[1;36m'
GREEN='\033[38;5;40m'    # FG[040] — conda
ORANGE='\033[38;5;208m'  # FG[208] — git
YELLOW='\033[33m'
RESET='\033[0m'

# -- Read JSON from stdin --
json="$(cat)"

# -- Parse fields from JSON --
current_dir="$(echo "$json" | jq -r '.workspace.current_dir // empty')"
model="$(echo "$json" | jq -r '.model.display_name // .model // empty')"
context_pct="$(echo "$json" | jq -r '.context_window.used_percentage // 0')"

# Shorten directory: replace $HOME with ~
current_dir="${current_dir/#$HOME/~}"

# -- Conda env (from environment, not JSON) --
conda_part=""
if [[ -n "${CONDA_DEFAULT_ENV:-}" ]]; then
    conda_part="${GREEN}conda:(${RESET}${CONDA_DEFAULT_ENV}${GREEN})${RESET} "
fi

# -- Git branch (via git command) --
git_part=""
git_branch="$(git -c gc.auto=0 rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
if [[ -n "$git_branch" ]]; then
    git_part="${ORANGE}git:(${RESET}${git_branch}${ORANGE})${RESET} "
fi

# -- Model name --
model_part=""
if [[ -n "$model" ]]; then
    model_part="[${model}] "
fi

# -- Context used --
ctx_part=""
if [[ -n "$context_pct" ]]; then
    pct_int="${context_pct%.*}"
    if (( pct_int < 50 )); then
        ctx_color='\033[32m'
    elif (( pct_int < 80 )); then
        ctx_color="${YELLOW}"
    else
        ctx_color='\033[31m'
    fi
    ctx_part="${ctx_color}${pct_int}%%${RESET} "
fi

# -- Assemble output --
printf "${BOLD_CYAN}${current_dir}${RESET} ${conda_part}${git_part}${model_part}${ctx_part}~>"
