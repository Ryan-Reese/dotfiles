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
- Whenever implementing a bug fix or new feature, always do so in a new sensibly-named Git worktree
- The `main` worktree should be kept in a `main` folder kept in the root folder of the project
- Once changes have been committed, they should be merged back into main
- Upon successful merging into main, the secondary worktree can be removed

### Follow Conventional Commits
- Whenever committing or submitting a pull request, always follow the Conventional Commits 1.0.0 Specification, which can be found for example at https://www.conventionalcommits.org/en/v1.0.0/

### Follow SemVer
- Whenever releasing different versions of a package, always follow the Semantic Versioning 2.0.0 Specification, which can be found for example at https://semver.org/

## Project Layout

When creating ANY new project:

### Required Files
- `.env` - Environment variables (NEVER commit)
- `.env.example` - Template with placeholders
- `CLAUDE.md` - Project overview
- `.gitignore` - Must include: .env, dist/, and follow the gitignore
for the respective language found in GitHub's gitignore repository
which can be accessed by SSH at `git@github.com:github/gitignore.git`

### Required Structure
branch/
├── src/
├── tests/
├── docs/
└── scripts/

### Python-Specific Requirements
- ALWAYS ensure a virtual environment is activated
- ALWAYS create and use virtual environments with `conda`
- ALWAYS manage packages in the virtual environment using `uv`
- ALWAYS perform linting using `ruff` when committing changes
