# Use Case: Cancel Operation Mid-Flow

## User Goal

Abort an operation (like directory selection or new repo creation) without side effects.

## User Actions

1. User presses Ctrl+C during any interactive prompt or selection
2. Or user selects "Cancel" option where available

## System Behavior

- System detects interrupt signal
- System cleanly aborts current operation
- System does not create partial resources
- System does not leave tmux in inconsistent state
- System provides feedback that operation was cancelled

## Outcome

- Operation is cancelled cleanly
- No partial or inconsistent state
- User can try again or do something else

## Example

```bash
$ muxxer myproject
# [Session "myproject" not found. Select directory:]
# [Shows directory list in fzf]
# User presses: Ctrl+C
# [Operation cancelled.]
# $ (back to prompt, no changes made)
```

## User Requirements (to be added)

-
-
