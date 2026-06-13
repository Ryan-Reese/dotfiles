#!/usr/bin/env bash
# Claude Code status line — mirrors robbyrussell zsh theme
# Reads JSON from stdin, outputs a formatted ANSI status line

set -euo pipefail

# -- Colors (matching robbyrussell theme) --
BOLD_CYAN='\033[1;36m'
GREEN='\033[38;5;40m'    # FG[040] — conda
ORANGE='\033[38;5;208m'  # FG[208] — git
RESET='\033[0m'

# -- Context-bar + PR palette (muted, tuned to the orange/green vibe) --
CTX_OK='\033[38;5;72m'    # <70%    muted green
CTX_WARN='\033[38;5;178m' # 70–89%  gold
CTX_HIGH='\033[38;5;166m' # 90%+    rust
DRAFT='\033[38;5;245m'    # PR draft  grey

# -- Read JSON from stdin --
json="$(cat)"

# -- Parse fields from JSON --
current_dir="$(jq -r '.workspace.current_dir // empty' <<<"$json")"
model="$(jq -r '.model.display_name // .model.id // empty' <<<"$json")"
context_pct="$(jq -r '.context_window.used_percentage // empty' <<<"$json")"
pr_num="$(jq -r '.pr.number // empty' <<<"$json")"
pr_state="$(jq -r '.pr.review_state // empty' <<<"$json")"

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

# -- Open PR (conditional — only when a PR exists for the branch) --
pr_part=""
if [[ -n "$pr_num" ]]; then
    case "$pr_state" in
        approved)          pr_color="$CTX_OK";   pr_glyph="✓" ;;
        changes_requested) pr_color="$CTX_HIGH"; pr_glyph="✗" ;;
        draft)             pr_color="$DRAFT";    pr_glyph="◌" ;;
        *)                 pr_color="$CTX_WARN"; pr_glyph="•" ;;  # pending / unknown
    esac
    pr_part="${pr_color}pr:(#${pr_num} ${pr_glyph})${RESET} "
fi

# -- Model name --
model_part=""
if [[ -n "$model" ]]; then
    model_part="[${model}] "
fi

# -- Context window: color-coded progress bar --
ctx_part=""
if [[ -n "$context_pct" ]]; then
    pct_int="${context_pct%.*}"
    [[ -z "$pct_int" ]] && pct_int=0
    if   (( pct_int >= 90 )); then bar_color="$CTX_HIGH"
    elif (( pct_int >= 70 )); then bar_color="$CTX_WARN"
    else                           bar_color="$CTX_OK"; fi

    width=10
    filled=$(( pct_int * width / 100 ))
    (( filled > width )) && filled=$width
    empty=$(( width - filled ))

    bar=""
    (( filled > 0 )) && printf -v fill "%${filled}s" && bar="${fill// /▓}"
    (( empty  > 0 )) && printf -v pad  "%${empty}s"  && bar="${bar}${pad// /░}"

    ctx_part="${bar_color}${bar} ${pct_int}%%${RESET} "
fi

# -- Assemble output --
printf "${BOLD_CYAN}${current_dir}${RESET} ${conda_part}${git_part}${pr_part}${model_part}${ctx_part}~>"
