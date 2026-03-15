# Contributing

## Development Setup

### Prerequisites

- bash 4.0+
- tmux
- fzf
- git
- GitHub CLI (`gh`) for GitHub integration
- Nix (optional, for testing nix-shell features)

### Clone and Setup

```bash
git clone https://github.com/yourusername/muxxer.git
cd muxxer

# Create symlink for development
./bin/muxxer --version
```

The first run creates a symlink at `~/.local/bin/muxxer`.

### Directory Structure

```
muxxer/
  bin/muxxer           # Entry point
  lib/                 # Library modules
  defaults/            # Default files
  doc/                 # Documentation
  plan/                # Original design docs (deprecated)
```

## Development Workflow

### Making Changes

1. Edit source files in `lib/` or `bin/`
2. Test manually with `./bin/muxxer`
3. Verify error handling and edge cases
4. Update documentation if behavior changes

### Testing

No automated test suite currently. Manual testing:

```bash
# Test session list
./bin/muxxer

# Test session creation
./bin/muxxer test-project

# Test new repo workflow
./bin/muxxer new-test-project
# Select "NEW REPO"

# Test cancellation
./bin/muxxer test-project
# Press Ctrl+C at various points

# Test error scenarios
./bin/muxxer "invalid session name!"
```

### Code Style

#### Shellcheck

All code should pass shellcheck:

```bash
shellcheck lib/**/*.sh bin/muxxer
```

#### Formatting

- Use 4-space indentation (no tabs)
- Functions use `snake_case`
- Constants use `UPPER_SNAKE_CASE`
- Namespaced functions use `module::function()`

#### Strict Mode

All scripts use:

```bash
set -euo pipefail
```

#### Error Handling

```bash
# Good: explicit error handling
if ! tmux::session_exists "$session"; then
    log::info "Session not found, creating..."
fi

# Bad: suppressing errors
tmux has-session -t "$session" 2>/dev/null || true
```

#### Logging

```bash
log::info "Informative message"
log::success "Operation completed"
log::warning "Something might be wrong"
log::error "Something failed"  # Goes to stderr
```

## Module Guidelines

### Single Responsibility

Each module should have one clear purpose:

- `tmux.sh` - only tmux operations
- `fzf.sh` - only fzf operations
- `config.sh` - only configuration management

### Namespace Prefix

```bash
# Good
tmux::create_session()
workflow::local::run()

# Bad
create_session()  # Could conflict
run_local()       # Unclear ownership
```

### Function Documentation

```bash
# Description of what the function does
# Arguments:
#   $1 - session name
#   $2 - working directory
# Returns:
#   0 on success, 1 on failure
tmux::create_session() {
    local session_name="${1:-}"
    local working_dir="${2:-}"
    # ...
}
```

### Default Values

```bash
# Use parameter expansion with defaults
local git_dir="${MUXXER_GIT_DIR:-$HOME/git}"
local visibility="${MUXXER_GITHUB_DEFAULT_VISIBILITY:-private}"
```

## Pull Request Process

1. Fork the repository
2. Create a feature branch
3. Make changes following code style guidelines
4. Test manually
5. Update documentation
6. Submit pull request

### PR Checklist

- [ ] Code passes shellcheck
- [ ] New functions use namespace prefix
- [ ] Error handling is explicit
- [ ] Logging is consistent
- [ ] Documentation updated if needed
- [ ] User-facing changes documented in `doc/user/`
- [ ] Developer changes documented in `doc/development/`

## Debugging

### Enable Verbose Output

Add debug logging:

```bash
log::info "Variable value: $my_var"
log::info "Entering function: workflow::local::run"
```

### Test Individual Functions

```bash
# Source required modules
source lib/core.sh
source lib/utils/logging.sh
source lib/tmux.sh

# Test function
tmux::session_exists "my-session"
echo $?
```

### Trace Execution

```bash
bash -x ./bin/muxxer myproject
```

## Common Issues

### Session Already Exists

If testing leaves orphan sessions:

```bash
tmux kill-session -t test-session
# Or kill all
tmux kill-server
```

### Config Issues

Reset to defaults:

```bash
rm -rf ~/.config/muxxer
./bin/muxxer --version  # Re-creates config
```

### Symlink Issues

Remove and recreate:

```bash
rm ~/.local/bin/muxxer
./bin/muxxer --version
```
