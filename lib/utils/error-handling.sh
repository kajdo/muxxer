# Error handling helpers for traps, cleanup, and fatal exits.

error::setup_trap() {
	trap 'error::cleanup; echo "Interrupted."; exit 130' SIGINT
	trap 'error::cleanup; echo "Terminated."; exit 143' SIGTERM
}

error::handle() {
	local error_msg="$1"
	local exit_code="${2:-1}"
	local suggestion="${3:-}"

	log::error "$error_msg"
	if [[ -n "$suggestion" ]]; then
		log::warning "Suggestion: $suggestion"
	fi
	exit "$exit_code"
}

error::cleanup() {
	:
}

error::directory_not_found() {
	local directory="$1"
	local exit_code=2

	log::error "Directory not found: $directory"
	log::warning "Suggestion: Check the path and create the directory if needed (e.g. mkdir -p \"$directory\")."
	return "$exit_code"
}

error::tmux_not_running() {
	local exit_code=3

	log::error "tmux server is not running."
	log::warning "Suggestion: Start tmux first (e.g. run 'tmux start-server' or open a new tmux session)."
	return "$exit_code"
}

error::session_not_found() {
	local session_name="$1"
	local exit_code=4

	log::error "Session not found: $session_name"
	log::warning "Suggestion: Create a new session (e.g. tmux new-session -s \"$session_name\")."
	return "$exit_code"
}

error::github_auth_failed() {
	local exit_code=5

	log::error "GitHub authentication failed."
	log::warning "Suggestion: Re-authenticate with GitHub CLI by running 'gh auth login'."
	return "$exit_code"
}

error::template_not_found() {
	local template_path="$1"
	local exit_code=6

	log::error "Template not found: $template_path"
	log::warning "Suggestion: Check your template directory path and confirm the template file exists."
	return "$exit_code"
}

error::permission_denied() {
	local path="$1"
	local exit_code=13

	log::error "Permission denied: $path"
	log::warning "Suggestion: Check file/directory permissions and ownership (e.g. ls -l, chmod, chown)."
	return "$exit_code"
}
