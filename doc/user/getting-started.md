# Getting Started

## Installation

### From Source

```bash
git clone https://github.com/yourusername/muxxer.git
cd muxxer
```

Add the `bin/muxxer` script to your PATH. On first run, muxxer creates a symlink at `~/.local/bin/muxxer`.

### Ensure PATH includes ~/.local/bin

Add to your shell configuration (`~/.bashrc` or `~/.zshrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## First Run

When you run muxxer for the first time:

1. Muxxer checks for GitHub CLI authentication
2. Creates the configuration directory at `~/.config/muxxer/`
3. Copies default configuration and templates
4. Creates a symlink at `~/.local/bin/muxxer`

You can also manually initialize or reset configuration using:

```bash
muxxer --init          # Initialize config (only if not exists)
muxxer --force-init    # Reset config to defaults (overwrites existing)
```

### What Gets Created

```
~/.config/muxxer/
  config                 # Your settings
  tmux-script.sh         # Default session layout
  shell-templates/       # shell.nix templates
    python310.nix
    python312.nix
    bash.nix
    go.nix
    flutter.nix
    README.md.template
```

### GitHub CLI Authentication

For GitHub integration (creating/cloning repos), authenticate first:

```bash
gh auth login
```

Without authentication, muxxer still works for local repositories but will warn you about limited functionality.

## Verify Installation

```bash
muxxer --version
# muxxer 0.1.0

muxxer --help
# Usage: muxxer [SESSION_NAME]
# ...
```

## Next Steps

- [Usage](usage.md) - Learn all workflows
- [Configuration](configuration.md) - Customize behavior
