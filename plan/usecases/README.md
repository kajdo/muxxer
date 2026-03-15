# User Use Cases

This directory contains user-facing use cases for muxxer. Each use case describes:

- **User Goal**: What the user wants to accomplish
- **User Actions**: What the user does (inputs, selections, commands)
- **System Behavior**: What happens (from user perspective, no technical details)
- **Outcome**: What result the user sees
- **User Requirements**: Section for you to add specific requirements

## How to Use

1. **Review each use case** to understand the intended workflow
2. **Add your requirements** in the "User Requirements" section
   - Be specific about what you expect
   - Describe behavior from your perspective as a user
   - Don't worry about implementation details
3. **Reference technical details** in `../muxxer-init.md` as needed
   - The design doc has the "how"
   - Use cases have the "what" and "why"

## Workflow

```
┌─────────────────┐
│  Review Use Case│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Add/Refine     │
│ Requirements   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Reference      │
│ muxxer-init.md │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Iterate        │
└─────────────────┘
```

## Use Cases

1. **[01-attach-existing-session.md](01-attach-existing-session.md)** - Attach to already-running session
2. **[02-create-session-local-repo.md](02-create-session-local-repo.md)** - Create session for existing repository
3. **[03-create-session-new-repo.md](03-create-session-new-repo.md)** - Create session for new repository
4. **[04-first-run-configuration.md](04-first-run-configuration.md)** - First-time setup
5. **[05-customize-configuration.md](05-customize-configuration.md)** - Customize behavior
6. **[06-list-sessions.md](06-list-sessions.md)** - List active sessions
7. **[07-cancel-operation.md](07-cancel-operation.md)** - Cancel mid-flow
8. **[08-get-help.md](08-get-help.md)** - Get help information
9. **[09-error-handling.md](09-error-handling.md)** - Error scenarios and recovery

## Notes

- These use cases focus on **user perspective only**
- Technical implementation details are in `../muxxer-init.md`
- Use cases are independent and can be refined in any order
- When adding requirements, think about:
  - What you want to happen
  - What you expect to see
  - What would make this experience good for you
  - Edge cases or special scenarios you care about

## Back-and-Forth Process

1. You add requirements to use cases
2. We discuss and refine based on technical feasibility
3. I reference `muxxer-init.md` to check if design supports it
4. If design needs changes, we update `muxxer-init.md`
5. Repeat until requirements are clear and achievable
