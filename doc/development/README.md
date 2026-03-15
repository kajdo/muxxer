# Muxxer Development Documentation

Documentation for contributors and developers extending muxxer.

## Architecture Overview

Muxxer is a modular bash application with clear separation of concerns:

```
bin/muxxer           # Entry point, argument parsing, main flow
lib/
  core.sh            # Constants, loader helpers
  config.sh          # Configuration management
  tmux.sh            # tmux operations
  fzf.sh             # fzf selection interfaces
  templates.sh       # Template operations
  workflows/
    local.sh         # Local repository workflow
    newrepo.sh       # New repository workflow
  utils/
    logging.sh       # Colored output
    error-handling.sh # Error handling and traps
    validation.sh    # Input validation
    project-detection.sh # Project type detection
defaults/
  config             # Default configuration
  tmux-script.sh     # Default session layout
  templates/         # Default shell.nix templates
```

## Documentation

| Document | Description |
|----------|-------------|
| [Architecture](architecture.md) | Module structure and patterns |
| [Extending](extending.md) | How to add features |
| [Contributing](contributing.md) | Development setup and guidelines |

## Quick Reference

### Module Loading Pattern

```bash
source "$LIB_DIR/core.sh"
source "$LIB_DIR/config.sh"
# etc.
```

### Namespacing Convention

All functions use double-colon namespace:

```bash
tmux::session_exists()
config::init()
workflow::local::run()
```

### Entry Point Flow

```
main()
  -> config::setup_symlink()
  -> error::setup_trap()
  -> config::init()
  -> if no args: handle_session_list_mode()
  -> if session exists: tmux::attach()
  -> else: handle_new_session_flow()
```
