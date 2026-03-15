# Configuration

## Configuration Location

Muxxer follows XDG Base Directory specification:

```
~/.config/muxxer/
  config              # Global settings
  tmux-script.sh      # Default session layout
  shell-templates/    # shell.nix templates
```

## Global Configuration

Edit `~/.config/muxxer/config`:

```bash
# Git settings
MUXXER_GIT_DIR="$HOME/git"

# Auto-creation flags (new repos only)
MUXXER_CREATE_SHELL_NIX="true"
MUXXER_CREATE_README="true"
MUXXER_INIT_GIT="true"

# GitHub integration
MUXXER_CREATE_GITHUB_REPO="true"
MUXXER_GITHUB_DEFAULT_VISIBILITY="private"
```

### Configuration Options

| Variable | Default | Description |
|----------|---------|-------------|
| `MUXXER_GIT_DIR` | `$HOME/git` | Directory containing git repositories |
| `MUXXER_CREATE_SHELL_NIX` | `true` | Auto-create shell.nix from template |
| `MUXXER_CREATE_README` | `true` | Auto-create README.md |
| `MUXXER_INIT_GIT` | `true` | Initialize git repository |
| `MUXXER_CREATE_GITHUB_REPO` | `true` | Default answer for "Create GitHub repo?" |
| `MUXXER_GITHUB_DEFAULT_VISIBILITY` | `private` | Default visibility (`public` or `private`) |

### Example: Custom Git Directory

```bash
# Store projects in ~/projects instead of ~/git
MUXXER_GIT_DIR="$HOME/projects"
```

### Example: Disable Auto-Creation

```bash
# Don't auto-create anything
MUXXER_CREATE_SHELL_NIX="false"
MUXXER_CREATE_README="false"
MUXXER_INIT_GIT="false"
MUXXER_CREATE_GITHUB_REPO="false"
```

## Per-Project Customization

Each project can have its own session layout via `.muxxer/tmux-script.sh`.

### When It's Created

The `.muxxer/` directory is created when you first open a project with muxxer. The global `tmux-script.sh` is copied to `.muxxer/tmux-script.sh`.

### Customizing Layout

Edit `.muxxer/tmux-script.sh` in your project:

```bash
#!/usr/bin/env bash
# Custom layout for myproject

# Create 4-pane grid
tmux split-window -h
tmux select-pane -L
tmux split-window -v
tmux select-pane -R
tmux split-window -v

# Run project-specific commands
tmux send-keys -t 0 "vim" C-m
tmux send-keys -t 1 "npm run dev" C-m
tmux send-keys -t 2 "npm test --watch" C-m
tmux send-keys -t 3 "git status" C-m

tmux select-pane -t 0
```

### Environment Variables Available

The script receives these environment variables:

| Variable | Description |
|----------|-------------|
| `MUXXER_PROJECT_TYPE` | Detected type (node, python, rust, go, flutter, nix, unknown) |
| `MUXXER_MAIN_COMMAND` | Suggested main command for the project |
| `MUXXER_TEST_COMMAND` | Suggested test command for the project |

Example usage in custom script:

```bash
#!/usr/bin/env bash

if [[ "$MUXXER_PROJECT_TYPE" == "node" ]]; then
    tmux send-keys "npm run dev" C-m
fi
```

## Default Session Script

The default `tmux-script.sh` behavior:

1. Split vertically (creates left and right panes)
2. In right pane: run `nix-shell` if `shell.nix` exists
3. Split left pane horizontally (creates bottom pane)
4. Resize bottom pane to 5 lines
5. Run `MUXXER_MAIN_COMMAND` in top-left if set
6. Run `MUXXER_TEST_COMMAND` in bottom-left if set
7. Focus top-left pane

## Validation

Muxxer validates configuration on startup:

- Warns if `MUXXER_GIT_DIR` does not exist
- Warns if `MUXXER_GITHUB_DEFAULT_VISIBILITY` is not `public` or `private`
- Warns if `MUXXER_CREATE_GITHUB_REPO` is not `true` or `false`
- Warns about unknown configuration keys

Warnings do not prevent muxxer from running. Invalid values fall back to defaults.
