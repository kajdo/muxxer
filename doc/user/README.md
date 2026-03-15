# Muxxer User Documentation

Muxxer is a simple, opinionated tmux session manager designed for developers who work with multiple git repositories.

## What Muxxer Does

- Creates and attaches to tmux sessions for your projects
- Provides fuzzy search over your git repositories
- Generates project scaffolding (shell.nix, README, git init)
- Integrates with GitHub for repository creation
- Detects project type and configures panes accordingly

## Quick Start

```bash
# Browse and attach to existing projects
muxxer

# Attach to or create a session (filtered by name)
muxxer myproject
```

## Documentation

| Document | Description |
|----------|-------------|
| [Getting Started](getting-started.md) | Installation and first run |
| [Usage](usage.md) | All use cases and workflows |
| [Configuration](configuration.md) | Global and per-project settings |
| [Templates](templates.md) | shell.nix templates for new projects |

## Requirements

- bash 4.0+
- tmux
- fzf
- git
- GitHub CLI (`gh`) - optional, for GitHub integration
- Nix - optional, for nix-shell support

## Philosophy

Muxxer is opinionated:

- Projects live in `~/git/` by default
- Sessions use a 3-pane layout (editor, shell, utility)
- Configuration is simple key=value format
- Per-project customization via `.muxxer/tmux-script.sh`
