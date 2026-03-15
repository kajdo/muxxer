# Use Case: Error Handling

## User Goal

Understand what happens when things go wrong and how muxxer recovers.

## Error Scenarios

### 1. Directory Not Found After Selection

**Trigger:** fzf returns a path that no longer exists (race condition, deleted between list and selection)

**System Behavior:**
- Validates directory exists before session creation
- Shows error: `[ERROR: Directory not found: /path/to/dir]`
- Returns to directory selection (doesn't exit)

### 2. tmux Command Fails

**Trigger:** `tmux new-session` or `tmux attach-session` fails (rare, but possible)

**System Behavior:**
- Captures tmux error output
- Shows error: `[ERROR: tmux failed: <error message>]`
- Exits with code 1

### 3. Template File Missing

**Trigger:** Selected template doesn't exist in `~/.config/muxxer/shell-templates/`

**System Behavior:**
- Validates template exists before copying
- Shows error: `[ERROR: Template not found: python312.nix]`
- Returns to template selection

### 4. GitHub CLI Not Authenticated (New Repo Workflow)

**Trigger:** User selects "NEW REPO" but `gh auth status` fails

**System Behavior:**
- Shows: `[ERROR: Not authenticated with GitHub CLI]`
- Shows: `[Please run: gh auth login]`
- Exits workflow gracefully (code 1)

### 5. GitHub Repository Creation Fails

**Trigger:** `gh repo create` fails (rate limit, network, permissions)

**System Behavior:**
- Shows: `[ERROR: Failed to create GitHub repository: <error>]`
- Local directory is still created (doesn't rollback)
- Shows: `[You can create the repo manually and add remote: git remote add origin <url>]`

### 6. Git Clone Fails

**Trigger:** `git clone` fails (network, auth, repo doesn't exist)

**System Behavior:**
- Shows: `[ERROR: Failed to clone repository: <error>]`
- No directory created
- Returns to directory selection

### 7. Permission Denied

**Trigger:** Can't write to `$MUXXER_GIT_DIR` or project directory

**System Behavior:**
- Shows: `[ERROR: Permission denied: <path>]`
- Shows: `[Check directory permissions]`
- Exits with code 1

### 8. Invalid Configuration

**Trigger:** Config file has invalid values (e.g., `MUXXER_GIT_DIR` points to non-existent path)

**System Behavior:**
- Shows: `[WARNING: Invalid config value: MUXXER_GIT_DIR=<value>]`
- Falls back to default: `~/git`
- Continues with warning

## General Error Principles

1. **Never leave partial state** - If multi-step operation fails, don't create orphan files
2. **Clear error messages** - Include what failed and why
3. **Suggest fix** - Tell user what to do next
4. **Graceful exit** - Clean up before exiting
5. **Warnings vs Errors** - Warnings continue, errors exit

## User Requirements (to be added)

-
-
