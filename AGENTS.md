# Dotfiles

Personal dotfiles managed via [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

- Repo root (`~/dotfiles`) is the Stow directory; every top-level file/folder is stowed into `$HOME`
- Restow after changes: `cd ~/dotfiles && stow -R .`
- `.stow-local-ignore` controls what Stow excludes (replaces Stow defaults when present, so `.git` and `.gitignore` must be re-listed)

### Adding New Configs

Files mirror their `$HOME` path: `~/dotfiles/.config/foo/bar.conf` stows to `~/.config/foo/bar.conf`. To add a new config:
1. Place the file at its `$HOME`-relative path inside `~/dotfiles/`
2. Run `stow -R .` to create symlinks
3. If the file should NOT be stowed, add it to `.stow-local-ignore`

## Managed Configs

| Path | Purpose |
|------|---------|
| `.zshrc`, `.zprofile`, `.profile`, `.bash_profile` | Shell config |
| `.config/nvim/` | Neovim (Lazy.nvim plugin manager) |
| `.config/tmux/` | tmux |
| `.config/git/` | Git config + global ignore |
| `.config/gh/` | GitHub CLI |
| `.ssh/config` | SSH config (keys are gitignored) |
| `.claude/` | Claude Code user-scope settings |
| `.codex/` | Codex user-scope settings |
| `.condarc` | Conda config |

## Commands

| Command | Description |
|---------|-------------|
| `cd ~/dotfiles && stow -R .` | Restow all (run after any change) |
| `cd ~/dotfiles && stow -n -R . 2>&1` | Dry-run - preview what stow would do |
| `cd ~/dotfiles && stow -D .` | Unstow all (remove symlinks) |

## Agent Config

- `.codex/AGENTS.md` is the canonical global agent instruction file
- `.claude/CLAUDE.md` is a compatibility symlink to `../.codex/AGENTS.md`
- Root `AGENTS.md` documents this dotfiles repo
- Root `CLAUDE.md` is a compatibility symlink to `AGENTS.md`
- `.claude/settings.json`, `keybindings.json`, and `statusline-command.sh` are **user-scope** -- stowed into `~/.claude/`
- `.codex/config.toml` and `.codex/themes/` are **user-scope** -- stowed into `~/.codex/`
- `.claude/settings.local.json` is **project-scope** only -- excluded from Stow via `.stow-local-ignore` and gitignored
- Do NOT add runtime/session files (`projects/`, `plans/`, `debug/`, `sessions/`, caches, etc.) to version control

## Gotchas

- `.keys` in repo root contains exported API keys (sourced by shell) - gitignored, NEVER commit or read its contents
- `.stow-local-ignore` **replaces** Stow's default ignore list - if you remove it or empty it, `.git` will be stowed
- Root `AGENTS.md` and `CLAUDE.md` are repo documentation, not user-scope agent config; they are excluded from Stow
- `.config/.DS_Store` exists locally - ensure it stays gitignored or remove it
- SSH private keys (`.ssh/main`) and `known_hosts*` are gitignored - only `.ssh/config` is tracked (`.ssh/agent/` contains runtime socket files, not version-controlled content)
