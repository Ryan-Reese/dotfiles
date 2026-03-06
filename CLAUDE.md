# Dotfiles

Personal dotfiles managed via [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

- Repo root (`~/dotfiles`) is the Stow directory; every top-level file/folder is stowed into `$HOME`
- Restow after changes: `cd ~/dotfiles && stow -R .`
- `.stow-local-ignore` controls what Stow excludes (replaces Stow defaults when present, so `.git` and `.gitignore` must be re-listed)

## Claude Config

- `.claude/CLAUDE.md`, `settings.json`, `keybindings.json`, `statusline-command.sh` are **user-scope** -- stowed into `~/.claude/`
- `.claude/settings.local.json` is **project-scope** only -- excluded from Stow via `.stow-local-ignore` and gitignored
- Do NOT add runtime/session files (`projects/`, `plans/`, `debug/`, etc.) to version control
