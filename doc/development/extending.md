# Extending Muxxer

## Adding Shell Templates

1. Create a new `.nix` file in `~/.config/muxxer/shell-templates/`:

```bash
cat > ~/.config/muxxer/shell-templates/rust.nix << 'EOF'
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt
  ];

  shellHook = ''
    echo "Rust $(rustc --version) ready"
  '';
}
EOF
```

2. The template automatically appears in the selection menu.

### Adding to Defaults

To include a template in the muxxer distribution:

1. Add file to `defaults/templates/`
2. Update `defaults/config` if needed
3. Document in `doc/user/templates.md`

## Adding Project Type Detection

Edit `lib/utils/project-detection.sh`:

```bash
project::detect_type() {
    local directory="$1"

    # Add new detection
    if [[ -f "$directory/Makefile" ]]; then
        echo "make"
        return 0
    fi

    # ... existing detection ...
}
```

Then add command mappings:

```bash
project::get_main_command() {
    # ...
    case "$project_type" in
        make)
            echo "make run"
            ;;
        # ...
    esac
}

project::get_test_command() {
    # ...
    case "$project_type" in
        make)
            echo "make test"
            ;;
        # ...
    esac
}
```

## Adding a New Workflow

### 1. Create Workflow Module

Create `lib/workflows/myworkflow.sh`:

```bash
workflow::myworkflow::run() {
    local session_name="${1:-}"
    local param="${2:-}"

    log::info "Starting my workflow"

    # Your logic here

    workflow::local::run "$session_name" "$directory"
}

# Export if needed for subshells
export -f workflow::myworkflow::run
```

### 2. Register in Entry Point

Edit `bin/muxxer`:

```bash
source "$LIB_DIR/workflows/myworkflow.sh"
```

### 3. Add Dispatch Logic

```bash
handle_my_workflow() {
    local session_name="${1:-}"
    workflow::myworkflow::run "$session_name"
}
```

## Adding fzf Selection Types

Edit `lib/fzf.sh`:

```bash
fzf::select_custom() {
    local items=("$@")
    local selected=""

    selected="$(printf '%s\n' "${items[@]}" | fzf::pick "cat")"

    if [[ -z "$selected" ]]; then
        printf '%s' ""
        return 0
    fi

    printf '%s\n' "$selected"
}
```

## Adding Configuration Options

### 1. Add to Default Config

Edit `defaults/config`:

```bash
MUXXER_MY_NEW_OPTION="default_value"
```

### 2. Add to Config Module

Edit `lib/config.sh`:

```bash
config::init() {
    # ... existing ...

    MUXXER_MY_NEW_OPTION="${MUXXER_MY_NEW_OPTION:-default_value}"
    export MUXXER_MY_NEW_OPTION
}
```

### 3. Add Validation

Edit `config::validate()`:

```bash
config::validate() {
    local known_keys=(
        # ... existing ...
        MUXXER_MY_NEW_OPTION
    )

    # ... validation logic ...
}
```

### 4. Use in Code

```bash
if [[ "${MUXXER_MY_NEW_OPTION:-default}" == "value" ]]; then
    # do something
fi
```

## Customizing Session Layout

### Global Default

Edit `defaults/tmux-script.sh`:

```bash
#!/usr/bin/env bash

# Custom global layout
tmux split-window -h
tmux split-window -v -t 0
tmux select-pane -t 0
```

### Per-Project Override

Users create `.muxxer/tmux-script.sh` in their project:

```bash
#!/usr/bin/env bash

# Project-specific layout
tmux split-window -h
tmux send-keys -t 0 "vim" C-m
tmux send-keys -t 1 "docker-compose up" C-m
```

## Adding Error Types

Edit `lib/utils/error-handling.sh`:

```bash
error::my_custom_error() {
    local detail="$1"
    local exit_code=20

    log::error "My custom error: $detail"
    log::warning "Suggestion: how to fix this"
    return "$exit_code"
}
```

## Adding Validation Functions

Edit `lib/utils/validation.sh`:

```bash
validation::my_check() {
    local value="$1"

    if [[ "$value" =~ ^pattern$ ]]; then
        return 0
    fi

    return 1
}
```

## Testing Extensions

### Manual Testing

```bash
# Test specific function
bash -c 'source lib/core.sh; source lib/utils/logging.sh; log::info "test"'

# Test workflow
./bin/muxxer test-session
```

### Integration Testing

1. Create test repository in `~/git/`
2. Run muxxer with test session name
3. Verify expected behavior

## Extension Guidelines

1. **Follow namespace convention**: `module::function()`
2. **Use logging**: `log::info`, `log::error`, etc.
3. **Handle errors gracefully**: use `error::` functions
4. **Validate inputs**: use `validation::` functions
5. **Make configurable**: add config options, not hardcoded values
6. **Document**: update user and developer docs
