# GLOBAL

## User Preferences

### GitHub Account
**ALWAYS** use **Ryan-Reese** for all projects:
- SSH: `git@github.com:Ryan-Reese/<repo>.git`

### GitLab NVIDIA Account
**ALWAYS** use **ryreese** for all projects:
- SSH: `git@gitlab-master.nvidia.com:ryreese/<repo>.git`

## NEVER EVER DO

These rules are ABSOLUTE:

### NEVER Mention Claude/AI in Outputs
- **No co-author lines**: Do NOT include `Generated with Claude Code`, `Co-Authored-By: Claude`, or similar attributions
- NEVER reference Claude, AI, or yourself in commit messages, PR descriptions, code comments, or any documentation

### NEVER Publish Sensitive Data
- NEVER publish passwords, API keys, tokens to git/npm/docker
- Before ANY commit: verify no secrets included

### NEVER Commit .env Files
- NEVER commit `.env` to git
- ALWAYS verify `.env` is in `.gitignore`

## Version Control
An example project layout would take the form:

project/
├── .git/
├── .gitignore/
├── .claude/
│   ├── skills/
│   ├── agents/
│   └── commands/
├── main/
├── feature-branch/
└── bug-fix-branch/

### ALWAYS Ensure Git Initialised
- Always ensure that the project is version-controlled using Git in the root folder of the project

### ALWAYS Work in Git Worktrees
- When implementing a bug fix or new feature in a multi-contributor project, prefer working in a new sensibly-named Git worktree
- For worktree-based repos, keep the `main` worktree in a `main` folder in the root of the project
- Once changes have been committed, they should be merged back into main
- Upon successful merging into main, the secondary worktree can be removed

Quick reference:
- Create: `git worktree add <path> -b <branch-name>`
- List: `git worktree list`
- Remove: `git worktree remove <path>`

### Follow Conventional Commits
- Whenever committing or submitting a pull request, always follow the Conventional Commits 1.0.0 Specification, which can be found for example at https://www.conventionalcommits.org/en/v1.0.0/

Format: `<type>(<optional scope>): <description>`
Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `ci`, `build`

### Follow SemVer
- Whenever releasing different versions of a package, always follow the Semantic Versioning 2.0.0 Specification, which can be found for example at https://semver.org/

## Project Layout

When creating a **new software project** (does not apply to config repos, dotfiles, or other non-standard layouts):

### Required Files
- `.env` - Environment variables (NEVER commit)
- `.env.example` - Template with placeholders
- `CLAUDE.md` - Project overview
- `.gitignore` - Must include: .env, dist/, and follow the gitignore
for the respective language found in GitHub's gitignore repository
which can be accessed by SSH at `git@github.com:github/gitignore.git`

### Required Structure
<worktree>/
├── src/       # Source code
├── tests/     # Test suites
├── docs/      # Documentation
└── scripts/   # Build/deploy scripts

### Python-Specific Requirements
- ALWAYS ensure a virtual environment is activated
- Run `conda_init` (defined in `.zshrc`) before using `conda` — it is not in PATH by default
- Prefer `conda` for creating virtual environments; fall back to `uv venv` if conda is unavailable
- ALWAYS manage packages in the virtual environment using `uv`
- ALWAYS perform linting using `ruff` when committing changes

Quick reference:
- Init conda: `conda_init` (required once per shell session)
- Create env: `conda create -n <name> python=<version>` (or `uv venv <name>`)
- Activate: `conda activate <name>` (or `source <name>/bin/activate`)
- Add package: `uv pip install <package>`
- Lint: `ruff check .`
- Format: `ruff format .`
