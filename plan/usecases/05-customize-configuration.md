# Use Case: Customize Configuration

## User Goal

Adjust muxxer behavior to match personal preferences.

## User Actions

1. User edits configuration file: `~/.config/muxxer/config`
2. User modifies settings as desired
3. User runs muxxer normally

## System Behavior

- System loads configuration on each run
- System applies configuration settings to workflows
- System validates configuration (optional enhancement)
- System uses fallback defaults if settings are invalid

## Common Settings to Customize

### Global Config (`~/.config/muxxer/config`)

| Variable | Default | Description |
|----------|---------|-------------|
| `MUXXER_GIT_DIR` | `$HOME/git` | Directory containing git repositories |
| `MUXXER_CREATE_SHELL_NIX` | `true` | Auto-create shell.nix from template (new repos only) |
| `MUXXER_CREATE_README` | `true` | Auto-create README.md (new repos only) |
| `MUXXER_INIT_GIT` | `true` | Initialize git repository (new repos only) |
| `MUXXER_CREATE_GITHUB_REPO` | `true` | Default answer for "Create GitHub repo?" prompt |
| `MUXXER_GITHUB_DEFAULT_VISIBILITY` | `private` | Default visibility (public/private) |

### Per-Project Layout (`./.muxxer/tmux-script.sh`)

- Edit `./.muxxer/tmux-script.sh` in a specific project directory for custom pane layouts
- Projects without this file use the global default from `~/.config/muxxer/tmux-script.sh`

## Outcome

- Muxxer behaves according to user preferences
- Settings persist across sessions
- All workflows respect custom configuration

## Example

**Global Configuration:**
```bash
# User edits ~/.config/muxxer/config

# Change git directory
MUXXER_GIT_DIR="$HOME/projects"

# Disable auto-creation features
MUXXER_CREATE_SHELL_NIX="false"
MUXXER_CREATE_README="false"
MUXXER_INIT_GIT="false"

# GitHub defaults
MUXXER_CREATE_GITHUB_REPO="false"
MUXXER_GITHUB_DEFAULT_VISIBILITY="public"

# Next run uses these settings
$ muxxer myproject
# [Searches in: ~/projects instead of ~/git]
# [No auto-creation of shell.nix, README, or git init]
# [Will not prompt for GitHub repository creation]
```

## Notes

**When `.muxxer/` is created:**
- The `.muxxer/` directory is created when you **first open a project** with muxxer (not on muxxer's first run overall)
- Default script provides: vertical split, nix-shell detection, bottom pane at 5 lines height
- Edit the script in your project directory to customize that project's layout only

## User Requirements (to be added)

-
-
