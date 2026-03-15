# Use Case: Get Help Information

## User Goal

Understand how to use muxxer and what commands are available.

## User Actions

1. User runs: `muxxer --help` or `muxxer -h`

## System Behavior

- System displays usage information
- System shows available commands and options
- System provides examples
- System may link to documentation

## Outcome

- User understands how to use muxxer
- User knows available features
- User can find more detailed documentation if needed

## Example

```bash
$ muxxer --help
# Muxxer - Simple tmux session manager for NixOS
#
# Usage:
#   muxxer                         Show interactive list of sessions (fzf)
#   muxxer <session_name>          Attach to or create session
#   muxxer --version               Show version
#   muxxer --help                  Show this help
#
# Examples:
#   muxxer                         Show all sessions and attach to selected one
#   muxxer myproject               Attach to or create session for 'myproject'
#   muxxer api                     Attach to or create session for 'api'
#
# Configuration: ~/.config/muxxer/config
# Documentation: See README.md
```

## User Requirements (to be added)

-
-
