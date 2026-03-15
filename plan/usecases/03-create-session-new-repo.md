# Use Case: Create Session for New Repository

## User Goal

Start a new project from scratch with proper development environment.

## User Actions

1. User runs: `muxxer <session_name>`
2. System shows directory list with "NEW REPO" option
3. User selects "NEW REPO"
4. System prompts for repository name (suggestion: session_name)
5. System checks if GitHub repository exists
6. **If repository exists on GitHub:**
   - System shows repository details (URL, visibility)
   - System asks: "Clone this repository? (y/n)"
7. **If repository doesn't exist on GitHub:**
    - System prompts for shell template (selection menu based on available templates in `~/.config/muxxer/shell-templates/`)
    - System asks: "Create GitHub repository? (y/n)" - default value shown in UPPERCASE, pressing Enter accepts default
    - If yes: System prompts for visibility (public or private) - default value shown in UPPERCASE, pressing Enter accepts default
8. (Optional) User confirms or modifies repository name

## System Behavior

- System shows "NEW REPO" as first option in directory list
- After selection, system checks if user is authenticated with gh CLI
- If not authenticated: prints warning and ends workflow
- **If authenticated:** system checks GitHub for repository existence (using gh CLI)
- **If repository exists on GitHub:**
  - Shows repository URL and visibility
  - Clones it to git folder
  - Repository already has shell.nix and README.md
- **If repository doesn't exist on GitHub:**
  - Creates new GitHub repository (if user confirms)
  - Copies selected shell.nix template to project directory
  - Generates README.md template
  - Initializes git repository
- Sets remote origin to GitHub repository
- Creates and attaches tmux session

## Notes

**GitHub CLI Authentication:**
- Assumes `gh auth login` was already completed before running muxxer
- Checks authentication status before performing GitHub operations
- If not authenticated: prints warning and ends workflow gracefully
- Separation of concerns: authentication setup is outside muxxer scope
- Git operations use gh as credential helper (no .gitcredentials needed)

**Default Values:**
- Default values for GitHub repository creation and visibility are set in `~/.config/muxxer/config`
- Defaults are displayed in UPPERCASE in prompts (e.g., `(Y/n)` means "yes" is the default)
- Pressing Enter without typing anything accepts the default value
- Configuration defaults: `MUXXER_CREATE_GITHUB_REPO="true"`, `MUXXER_GITHUB_DEFAULT_VISIBILITY="private"`

## Outcome

- New project directory in git folder
- Development environment ready (shell.nix present)
- Git repository ready (initialized or cloned)
- GitHub repository accessible (created or existing)
- Remote origin configured
- tmux session attached and configured

## Example - New Repository

```bash
$ muxxer mynewproject
# [Session "mynewproject" not found. Select directory:]
# User selects: NEW REPO
# [Enter repository name: mynewproject]
# [Checking GitHub CLI authentication status...]
# [Authenticated]
# [Checking if repository exists on GitHub...]
# [Repository not found: username/mynewproject]
# [Create GitHub repository? (Y/n):] y
# [Select shell template:]
#   python310.nix
#   python312.nix
#   bash.nix
#   go.nix
#   flutter.nix
# User selects: python312.nix
# [Repository visibility? (public/PRIVATE):] private
# [Creating GitHub repository using gh CLI...]
# [Created directory: ~/git/mynewproject]
# [Copied shell template: python312.nix]
# [Created README.md]
# [Initialized git repository]
# [Set remote origin]
# [Creating tmux session...]
# [Attached to session 'mynewproject']
```

## Example - Existing Repository

```bash
$ muxxer existing-repo
# [Session "existing-repo" not found. Select directory:]
# User selects: NEW REPO
# [Enter repository name: existing-repo]
# [Checking GitHub CLI authentication status...]
# [Authenticated]
# [Checking if repository exists on GitHub...]
# [Repository found: https://github.com/username/existing-repo (public)]
# [Clone this repository? (y/n):] y
# [Cloning repository: git@github.com:username/existing-repo]
# [Created directory: ~/git/existing-repo]
# [Set remote origin]
# [Creating tmux session...]
# [Attached to session 'existing-repo']
```

## Example - Not Authenticated

```bash
$ muxxer mynewproject
# [Session "mynewproject" not found. Select directory:]
# User selects: NEW REPO
# [Enter repository name: mynewproject]
# [Checking GitHub CLI authentication status...]
# [ERROR: Not authenticated with GitHub CLI]
# [Please run: gh auth login]
# [Workflow aborted]
```

## User Requirements (to be added)

-
-
