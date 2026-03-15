# Architecture

## File Structure

```
muxxer/
  bin/
    muxxer              # Main entry point
  lib/
    core.sh             # Shared constants and loader
    config.sh           # Configuration management
    tmux.sh             # tmux session operations
    fzf.sh              # fzf selection interfaces
    templates.sh        # Template operations
    workflows/
      local.sh          # Local repo workflow
      newrepo.sh        # New repo workflow
    utils/
      logging.sh        # Colored output helpers
      error-handling.sh # Error handling and traps
      validation.sh     # Input validation
      project-detection.sh # Project type detection
  defaults/
    config              # Default user config
    tmux-script.sh      # Default session script
    templates/
      python310.nix
      python312.nix
      bash.nix
      go.nix
      flutter.nix
      README.md.template
  doc/
    user/               # User documentation
    development/        # Developer documentation
```

## Module Responsibilities

### bin/muxxer

Entry point (122 lines). Responsibilities:

- Argument parsing (`--help`, `--version`, `--init`, `--force-init`, session name)
- Signal trap setup
- Configuration initialization
- Session existence check
- Workflow dispatching

### lib/core.sh

Core utilities (29 lines):

- `SCRIPT_DIR`, `LIB_DIR`, `DEFAULTS_DIR` constants
- `MUXXER_VERSION` constant
- `core::enable_strict_mode()` - enables `set -euo pipefail`
- `core::require()` - module loader helper
- Color constants (`RED`, `GREEN`, `YELLOW`, `BLUE`, `RESET`)

### lib/config.sh

Configuration management (138 lines):

- `config::copy_defaults()` - copies default files to user config
- `config::get()` - get config value with default
- `config::validate()` - validate configuration values
- `config::setup_symlink()` - create symlink in ~/.local/bin
- `config::init()` - initialize config on startup

### lib/tmux.sh

tmux operations (45 lines):

- `tmux::session_exists()` - check if session exists
- `tmux::attach()` - attach to session
- `tmux::create_session()` - create detached session
- `tmux::send_command()` - send keys to session
- `tmux::list_sessions()` - list all sessions
- `tmux::get_session_info()` - get session metadata

### lib/fzf.sh

fzf interfaces (142 lines):

- `fzf::pick()` - generic fzf wrapper with common options
- `fzf::preview_directory()` - preview directory (README or ls)
- `fzf::select_directory()` - directory selection with preview
- `fzf::select_session()` - session selection with preview
- `fzf::select_language()` - template selection with preview

### lib/templates.sh

Template operations (44 lines):

- `templates::list()` - list available templates
- `templates::copy()` - copy template to destination
- `templates::generate_readme()` - generate README from template

### lib/workflows/local.sh

Local repository workflow (66 lines):

- `workflow::local::setup_project_layout()` - create .muxxer directory
- `workflow::local::create_session()` - create tmux session
- `workflow::local::run()` - orchestrate local workflow

### lib/workflows/newrepo.sh

New repository workflow (230 lines):

- `workflow::newrepo::run()` - orchestrate new repo workflow
- `workflow::newrepo::repo_exists_on_github()` - check GitHub for repo
- `workflow::newrepo::clone_repo()` - clone existing repository
- `workflow::newrepo::check_github_auth()` - verify GitHub CLI auth
- `workflow::newrepo::create_directory()` - create and init git repo

### lib/utils/logging.sh

Logging helpers (17 lines):

- `log::info()` - blue [INFO] messages
- `log::success()` - green [SUCCESS] messages
- `log::error()` - red [ERROR] messages (to stderr)
- `log::warning()` - yellow [WARNING] messages

### lib/utils/error-handling.sh

Error handling (74 lines):

- `error::setup_trap()` - setup SIGINT/SIGTERM handlers
- `error::handle()` - generic error handler with suggestion
- `error::cleanup()` - cleanup placeholder
- `error::directory_not_found()` - specific error handlers
- `error::tmux_not_running()`
- `error::session_not_found()`
- `error::github_auth_failed()`
- `error::template_not_found()`
- `error::permission_denied()`

### lib/utils/validation.sh

Input validation (45 lines):

- `validation::directory_exists()` - check directory
- `validation::file_exists()` - check file
- `validation::command_exists()` - check command availability
- `validation::github_auth_check()` - check GitHub CLI auth
- `validation::require_command()` - require command or exit
- `validation::session_name_valid()` - validate session name format

### lib/utils/project-detection.sh

Directory validation helpers (17 lines):

- `project::is_valid_directory()` - validate directory
- `project::has_nix_shell()` - check for shell.nix/flake.nix

## Design Patterns

### Namespace Prefix

All functions use `module::function()` or `module::subcategory::function()` naming:

```bash
tmux::session_exists()
config::init()
workflow::local::run()
error::directory_not_found()
```

### Strict Mode

All scripts use:

```bash
set -euo pipefail
```

Enabled via `core::enable_strict_mode()` or explicitly in entry point.

### Module Loading

Modules are sourced in order of dependency:

```bash
source "$LIB_DIR/core.sh"           # First - defines constants
source "$LIB_DIR/utils/logging.sh"  # Logging (no dependencies)
source "$LIB_DIR/config.sh"         # Config (needs logging)
# etc.
```

### Error Handling

Errors use structured handlers:

```bash
if ! tmux::session_exists "$session"; then
    error::session_not_found "$session"
    return 1
fi
```

### fzf Integration

Consistent fzf options via wrapper:

```bash
fzf::pick() {
    fzf \
        --height 50% \
        --layout reverse \
        -i \
        --cycle \
        --preview "$preview_cmd" \
        --preview-window right:60% \
        --bind 'ctrl-c:abort'
}
```

### Configuration Pattern

XDG-compliant with fallbacks:

```bash
MUXXER_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/muxxer"
MUXXER_GIT_DIR="${MUXXER_GIT_DIR:-$HOME/git}"
```

## Data Flow

### Session Creation Flow

```
muxxer <name>
    |
    v
tmux::session_exists()?
    |-- yes --> tmux::attach() --> END
    |
    v
fzf::select_directory()
    |
    v
selection == "NEW REPO"?
    |-- yes --> workflow::newrepo::run()
    |              |
    |              v
    |           workflow::newrepo::create_directory()
    |           shell.nix exists?
    |           |-- yes --> skip shell.nix creation
    |           |-- no --> templates::copy()
    |           templates::generate_readme()
    |           gh repo create (optional)
    |           workflow::local::run()
    |
    |-- no --> workflow::local::run()
                   |
                   v
                workflow::local::setup_project_layout()
                   |
                   v
                .muxxer exists?
                |-- yes --> skip layout setup (preserve user config)
                |-- no --> create .muxxer/ with tmux-script.sh
                |
                v
                workflow::local::create_session()
                tmux::attach()
```

### Configuration Flow

```
config::init(force)
    |
    v
force mode or config doesn't exist?
    |-- yes --> config::copy_defaults(force)
    |              |
    |              v
    |           force mode?
    |           |-- yes --> remove existing shell-templates/
    |
    v
source config
    |
    v
apply defaults
    |
    v
config::validate()
```

## Environment Variables

### Muxxer-Specific

| Variable | Description |
|----------|-------------|
| `MUXXER_CONFIG` | Path to config file |
| `MUXXER_CONFIG_DIR` | Directory containing config and templates |
| `MUXXER_GIT_DIR` | Directory containing git repositories |

### XDG

| Variable | Description |
|----------|-------------|
| `XDG_CONFIG_HOME` | Base directory for config files (default: `~/.config`) |

### tmux

| Variable | Description |
|----------|-------------|
| `TMUX` | Set when inside tmux session |

## Command Reference

### tmux Commands Used

| Command | Purpose |
|---------|---------|
| `tmux has-session -t <name>` | Check if session exists |
| `tmux ls` | List all sessions |
| `tmux new-session -d -s <name>` | Create detached session |
| `tmux attach-session -t <name>` | Attach to session |
| `tmux send-keys -t <name> "<cmd>" C-m` | Send command to pane |
| `tmux split-window -h -t <name>` | Split pane horizontally |
| `tmux split-window -v -t <name>` | Split pane vertically |
| `tmux display-message -p` | Print tmux variable |

### fzf Options Used

| Option | Purpose |
|--------|---------|
| `--preview <cmd>` | Preview command |
| `--preview-window <spec>` | Preview window position/size |
| `-i` | Case-insensitive search |
| `--query <str>` | Initial query |
| `--height <pct>` | FZF window height |
| `--layout reverse` | Show results from top |
| `--cycle` | Cycle through results |
| `--bind <key:action>` | Key bindings |

### git Commands Used

| Command | Purpose |
|---------|---------|
| `git init` | Initialize repository |
| `git add -A` | Stage all files |
| `git commit -m` | Create commit |
| `git clone` | Clone repository |

### GitHub CLI Commands Used

| Command | Purpose |
|---------|---------|
| `gh auth status` | Check authentication |
| `gh api user` | Get current user |
| `gh repo view` | Check repo existence |
| `gh repo create` | Create repository |

## References

### Similar Tools

- [tmuxinator](https://github.com/tmuxinator/tmuxinator) - Ruby, YAML config
- [tmuxp](https://github.com/tmux-python/tmuxp) - Python, YAML/JSON config
- [tmux-sessionizer](https://github.com/ThePrimeagen/tmux-sessionizer) - Bash, directory-based

### External Documentation

- [tmux manual](https://man.openbsd.org/tmux.1)
- [fzf wiki](https://github.com/junegunn/fzf/wiki)
- [GitHub CLI manual](https://cli.github.com/manual/)
