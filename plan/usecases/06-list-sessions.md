# Use Case: List and Attach to Sessions

## User Goal

See all running tmux sessions managed by muxxer and quickly attach to one.

## User Actions

1. User runs: `muxxer` (no arguments)
2. User sees interactive list of sessions in fzf
3. User selects a session from the list (or presses ESC/q to cancel)

## System Behavior

- System queries tmux for all sessions
- System displays interactive fzf list with session information
- List shows: session name, associated directory, pane count, creation time
- User can search/filter sessions using fzf
- **If user selects a session:** System attaches to that session
- **If user cancels (ESC/q):** System exits without attaching

## Outcome

- User can see all active sessions in an interactive list
- User can quickly search and select a session to attach to
- User can cancel without attaching to any session

## Example

```bash
$ muxxer
# [Shows fzf interface with sessions:]
#   myproject    ~/git/myproject       [2 panes]    2 hours ago
#   api          ~/git/api-service     [3 panes]    1 day ago
#   docs         ~/git/documentation   [1 pane]     3 days ago
# >
# [User types: "api"]
# > api
#   api          ~/git/api-service     [3 panes]    1 day ago
# [User presses Enter]
# [Attaching to session 'api'...]
```

## Example - Cancel

```bash
$ muxxer
# [Shows fzf interface with sessions:]
#   myproject    ~/git/myproject       [2 panes]    2 hours ago
#   api          ~/git/api-service     [3 panes]    1 day ago
#   docs         ~/git/documentation   [1 pane]     3 days ago
# >
# [User presses ESC]
# [No session selected. Exiting...]
```

## Notes

**Default Behavior:**
- Running `muxxer` without arguments shows the session list
- This is the default and primary way to interact with muxxer
- No special `--list` argument needed

**Session Information Displayed:**
- Session name
- Associated directory path
- Number of panes in the session
- Creation time (relative, e.g., "2 hours ago", "1 day ago")

**fzf Features:**
- Search/filter by typing session name or directory path
- Use arrow keys to navigate
- Press Enter to select and attach
- Press ESC or Ctrl+C to cancel

## User Requirements (to be added)

-
-
