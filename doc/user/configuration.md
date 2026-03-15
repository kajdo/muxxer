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

### Config Management

Muxxer provides commands to manage your configuration:

#### Initialization

On first run, muxxer automatically creates the configuration directory and copies defaults to `~/.config/muxxer/`.

#### Manual Initialization

```bash
muxxer --init
```

Creates the configuration directory and copies defaults, but only if they don't already exist. Safe to run multiple times.

#### Reset to Defaults

```bash
muxxer --force-init
```

Overwrites your existing configuration with default values. Use with caution - this will:

- Replace `~/.config/muxxer/config` with defaults
- Replace `~/.config/muxxer/tmux-script.sh` with defaults
- Replace `~/.config/muxxer/shell-templates/` with default templates

Project-specific files (`.muxxer/` directories in your projects) are **not** affected.

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

**Important**: If `.muxxer/` already exists in the project directory, muxxer will NOT overwrite it. This preserves your customizations and project-specific configuration.

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

## Default Session Script

The default `tmux-script.sh` behavior:

1. Split vertically (creates left and right panes)
2. In right pane: run `nix-shell` if `shell.nix` exists
3. Split left pane horizontally (creates bottom pane)
4. Resize bottom pane to 5 lines
5. Focus top-left pane

## Validation

Muxxer validates configuration on startup:

- Warns if `MUXXER_GIT_DIR` does not exist
- Warns if `MUXXER_GITHUB_DEFAULT_VISIBILITY` is not `public` or `private`
- Warns if `MUXXER_CREATE_GITHUB_REPO` is not `true` or `false`
- Warns about unknown configuration keys

Warnings do not prevent muxxer from running. Invalid values fall back to defaults.
