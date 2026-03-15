# Use Case: First Run Configuration

## User Goal

Set up muxxer for the first time with default configuration.

## User Actions

1. User runs: `muxxer <session_name>` (first time ever)
2. No explicit configuration steps required

## System Behavior

- System detects no configuration exists
- System checks if user is authenticated with gh CLI
- If not authenticated: prints warning (does not end workflow)
- System automatically creates default configuration directory: `~/.config/muxxer/`
- System copies default config file from project's `./defaults/` directory
- System creates default template files by copying from project's `./defaults/templates/` directory
- System informs user about auto-creation

## Outcome

- Muxxer is ready to use without manual setup
- User can immediately start using muxxer
- Configuration can be customized later by editing the config file

## Example - Not Authenticated

```bash
$ muxxer myproject
# [Checking GitHub CLI authentication status...]
# [WARNING: Not authenticated with GitHub CLI]
# [If you want muxxer to work properly, run: gh auth login]
# [No configuration found. Creating default configuration...]
# [Created: ~/.config/muxxer/config (copied from ./defaults/)]
# [Created templates directory: ~/.config/muxxer/shell-templates/]
# [Copied default templates from ./defaults/templates/]
# [Configuration ready. Continuing...]
# [Session "myproject" not found. Select directory:]
```

## Example - Authenticated

```bash
$ muxxer myproject
# [Checking GitHub CLI authentication status...]
# [Authenticated]
# [No configuration found. Creating default configuration...]
# [Created: ~/.config/muxxer/config (copied from ./defaults/)]
# [Created templates directory: ~/.config/muxxer/shell-templates/]
# [Copied default templates from ./defaults/templates/]
# [Configuration ready. Continuing...]
# [Session "myproject" not found. Select directory:]
```

## Notes

**GitHub CLI Authentication:**
- Assumes `gh auth login` should be completed for full muxxer functionality
- Checks authentication status during first run
- If not authenticated: prints warning but does NOT end workflow
- Warning message: "If you want muxxer to work properly, run: gh auth login"
- Separation of concerns: authentication setup is outside muxxer scope
- GitHub operations (repo creation/clone) will fail without authentication

## User Requirements (to be added)

-
-
