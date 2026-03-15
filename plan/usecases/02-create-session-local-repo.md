# Use Case: Create Session for Existing Local Repository

## User Goal

Start working on an existing local repository that doesn't have a running session.

## User Actions

1. User runs: `muxxer <session_name>` where session_name matches part of directory name
2. System shows a list of matching directories from git folder
3. User selects a directory from the list
4. (Optional) User can preview README.md of directories while browsing

## System Behavior

- System searches git folder for directories matching session name (case-insensitive)
- System presents list in fuzzy finder with previews
- After selection, system creates a new tmux session for that directory
- System executes tmux-script.sh which handles shell.nix detection and nix-shell entry

## Outcome

- New tmux session created and attached
- tmux-script.sh configures the session layout (includes shell.nix detection)
- User can immediately start working

## Example

```bash
$ muxxer api
# [Session "api" not found. Select directory:]
# [Shows matching directories: my-api, api-service, api-tools]
# User selects: my-api
# [Creating session 'api' for directory: ~/git/my-api]
# [Executing tmux-script.sh]
```

## User Requirements (to be added)

-
-
