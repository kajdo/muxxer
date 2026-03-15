# Usage

## Basic Commands

### List and Attach to Sessions

```bash
muxxer
```

Shows an interactive list of all tmux sessions. Select one to attach, or press Escape to cancel.

The list displays:
- Session name
- Number of windows
- Preview of windows in the session

### Attach to Existing Session

```bash
muxxer myproject
```

If a session named `myproject` exists, muxxer attaches to it immediately. All panes and running processes are preserved.

### Create Session for Local Repository

```bash
muxxer myproject
```

If the session does not exist, muxxer searches your git directory (`~/git/` by default) for directories matching `myproject` (case-insensitive).

1. Fuzzy finder shows matching directories
2. Preview shows README.md or directory listing
3. Select a directory to create the session

The new session:
- Uses the 3-pane default layout
- Detects project type (Node, Python, Rust, Go, Flutter, Nix)
- Runs appropriate commands in panes (e.g., `nix-shell` for Nix projects)

### Create New Repository

When selecting a directory, choose `NEW REPO` to create a new project:

1. Enter repository name
2. Select a shell template (Python, Go, etc.)
3. Confirm GitHub repository creation
4. Muxxer creates:
   - Directory in `~/git/<repo_name>/`
   - `shell.nix` from selected template
   - `README.md` from template
   - Git repository with initial commit
   - GitHub repository (if confirmed)

## Workflows

### Local Repository Workflow

When you select an existing directory:

```
muxxer api
  -> Searches ~/git/*api*
  -> Shows: my-api, api-service, api-tools
  -> Select: my-api
  -> Creates session with detected project type
  -> Attaches to session
```

### New Repository Workflow

When you select `NEW REPO`:

```
muxxer newproject
  -> Session not found
  -> Directory selection shows "NEW REPO"
  -> Select: NEW REPO
  -> Enter name: newproject
  -> Select template: python312
  -> Create GitHub repo? [Y/n]: y
  -> Creates directory, files, git repo, GitHub repo
  -> Creates and attaches session
```

### Clone Existing GitHub Repository

If the repository exists on GitHub:

```
muxxer existing-repo
  -> Select: NEW REPO
  -> Enter name: existing-repo
  -> Found: github.com/user/existing-repo (public)
  -> Clone? [y/n]: y
  -> Clones repository
  -> Creates and attaches session
```

## Session Layout

The default layout creates 3 panes:

```
+-------------------+-------------------+
|                   |                   |
|   Editor/Main     |   Shell/Helper    |
|   (top-left)      |   (right)         |
|                   |                   |
+-------------------+                   |
|                   |                   |
|   Utility         |                   |
|   (bottom-left)   |                   |
|   5 lines         |                   |
+-------------------+-------------------+
```

### Adaptive Behavior

The layout adapts based on detected project type:

| Project Type | Main Pane Command | Utility Pane Command |
|--------------|-------------------|----------------------|
| Node | `npm run dev` | `npm test` |
| Python | `python main.py` | `pytest` |
| Rust | `cargo run` | `cargo test` |
| Go | `go run .` | `go test ./...` |
| Flutter | `flutter run` | `flutter test` |
| Nix | `nix-shell` | (none) |

Commands only run if the project detection is confident. Otherwise panes remain empty.

## Keyboard Shortcuts

During fzf selection:

| Key | Action |
|-----|--------|
| Enter | Select |
| Escape | Cancel |
| Ctrl+C | Cancel |
| Tab | Multi-select (where applicable) |
| Shift+Tab | Multi-select backward |
| Up/Down | Navigate |
| Type | Fuzzy filter |

## Cancellation

Press `Ctrl+C` at any point to cancel cleanly. No partial state is created.

## Error Handling

When things go wrong, muxxer provides clear error messages with suggestions.

### Common Error Scenarios

| Scenario | Behavior |
|----------|----------|
| Directory not found | Returns to directory selection |
| tmux command fails | Exits with error message |
| Template missing | Returns to template selection |
| GitHub CLI not authenticated | Shows warning, aborts new repo workflow |
| GitHub repo creation fails | Local directory created, manual remote setup suggested |
| Git clone fails | No directory created, returns to selection |
| Permission denied | Exits with error and suggestion |
| Invalid configuration | Warning shown, falls back to defaults |

### Error Message Format

Errors include:
- What failed
- Why it failed (when known)
- Suggested fix

Example:
```
[ERROR] Directory not found: /home/user/git/myproject
[WARNING] Suggestion: Check the path and create the directory if needed.
```

### Warnings vs Errors

- **Warnings**: muxxer continues with fallback behavior
- **Errors**: muxxer exits with non-zero status

## nix-shell Detection

When creating a session for a directory with `shell.nix`:

1. Muxxer detects the file exists
2. The right pane automatically runs `nix-shell`
3. Project type is detected as `nix`

This provides immediate access to your development environment.

## Command Line Options

```bash
muxxer                  # List sessions
muxxer <name>           # Attach or create session
muxxer --help           # Show help
muxxer --version        # Show version
```
