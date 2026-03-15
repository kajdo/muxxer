#!/usr/bin/env bash
# Default muxxer tmux session script
# Creates the default 3-pane development layout for a new session.

LEFT_TOP_PANE="$(tmux display-message -p '#{pane_id}')"

# The local workflow exports project metadata. Keep behavior backward-compatible
# by treating all of these as optional.
PROJECT_TYPE="${MUXXER_PROJECT_TYPE:-}"
PROJECT_TYPE_NORMALIZED="${PROJECT_TYPE,,}"
MAIN_COMMAND="${MUXXER_MAIN_COMMAND:-}"
TEST_COMMAND="${MUXXER_TEST_COMMAND:-}"

# If project type is known, surface it in tmux status feedback.
if [[ -n "$PROJECT_TYPE" ]]; then
	tmux display-message "muxxer: detected project type '$PROJECT_TYPE'"
fi

tmux split-window -h -t "$LEFT_TOP_PANE"
RIGHT_PANE="$(tmux display-message -p '#{pane_id}')"

# Adaptive right-pane bootstrap:
# - keep shell.nix detection for compatibility
# - also honor explicit nix project type from workflow metadata
if [[ "$PROJECT_TYPE_NORMALIZED" == "nix" || -f "shell.nix" ]]; then
	tmux send-keys -t "$RIGHT_PANE" "nix-shell" C-m
fi

tmux select-pane -t "$LEFT_TOP_PANE"

tmux split-window -v -t "$LEFT_TOP_PANE"
LEFT_BOTTOM_PANE="$(tmux display-message -p '#{pane_id}')"

tmux resize-pane -y 5 -t "$LEFT_BOTTOM_PANE"

# Adaptive command dispatch:
# - main command goes to top-left pane when provided
# - test command goes to bottom-left pane when provided
# Without env vars this keeps the original layout-only behavior.
if [[ -n "$MAIN_COMMAND" ]]; then
	tmux send-keys -t "$LEFT_TOP_PANE" "$MAIN_COMMAND" C-m
fi

if [[ -n "$TEST_COMMAND" ]]; then
	tmux send-keys -t "$LEFT_BOTTOM_PANE" "$TEST_COMMAND" C-m
fi

tmux select-pane -t "$LEFT_TOP_PANE"
