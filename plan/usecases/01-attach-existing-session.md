# Use Case: Attach to Existing Session

## User Goal

Attach to an already-running tmux session without reconfiguring anything.

## User Actions

1. User runs: `muxxer <session_name>`
2. No further interaction required

## System Behavior

- System checks if a session with that name is already running
- If found, immediately attaches to it
- Session continues exactly as it was (all panes, running processes preserved)

## Outcome

- User is connected to their existing session
- All work in progress is preserved
- No configuration or setup occurs

## Example

```bash
$ muxxer myproject
# [Session "myproject" already exists. Attaching...]
# User is now in their existing tmux session
```
