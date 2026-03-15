# Tmux session operations module for creating, querying, and controlling sessions.

tmux::session_exists() {
	local session_name="${1:-}"

	[[ -n "$session_name" ]] || return 1
	tmux has-session -t "$session_name" 2>/dev/null
}

tmux::attach() {
	local session_name="${1:-}"

	tmux attach-session -t "$session_name"
}

tmux::create_session() {
	local session_name="${1:-}"
	local working_dir="${2:-}"

	tmux new-session -d -s "$session_name" -c "$working_dir"
}

tmux::send_command() {
	local session_name="${1:-}"
	local command="${2:-}"

	tmux send-keys -t "$session_name" "$command" C-m
}

tmux::list_sessions() {
	tmux ls
}

tmux::get_session_info() {
	local session_name="${1:-}"
	local name=""
	local directory=""
	local pane_count=""

	name="$(tmux display-message -p -t "$session_name" "#{session_name}")"
	directory="$(tmux display-message -p -t "$session_name" "#{session_path}")"
	pane_count="$(tmux list-panes -t "$session_name" -F "#{pane_id}" | wc -l)"

	printf 'name=%s directory=%s panes=%s\n' "$name" "$directory" "$pane_count"
}
