# Local repository workflow module for preparing project layout and launching tmux sessions.

workflow::local::setup_project_layout() {
	local target_dir="${1:-}"
	local project_muxxer_dir=""
	local source_script=""
	local target_script=""

	if [[ -z "$target_dir" ]]; then
		log::error "Target directory is required for project layout setup"
		return 1
	fi

	project_muxxer_dir="$target_dir/.muxxer"
	source_script="$MUXXER_CONFIG_DIR/tmux-script.sh"
	target_script="$project_muxxer_dir/tmux-script.sh"

	if [[ ! -f "$source_script" ]]; then
		log::error "Missing tmux script in config directory: $source_script"
		return 1
	fi

	# Skip if .muxxer directory already exists (preserve user's project config)
	if [[ -d "$project_muxxer_dir" ]]; then
		log::info "Using existing project layout: $project_muxxer_dir"
		return 0
	fi

	mkdir -p "$project_muxxer_dir"
	cp "$source_script" "$target_script"
	chmod +x "$target_script"

	log::success "Project layout ready in $project_muxxer_dir"
}

workflow::local::create_session() {
	local session_name="${1:-}"
	local directory="${2:-}"
	local project_script=""
	local fallback_script=""
	local session_script=""

	if [[ -z "$session_name" || -z "$directory" ]]; then
		log::error "Session name and directory are required"
		return 1
	fi

	if tmux::session_exists "$session_name"; then
		log::info "Session '$session_name' already exists"
		return 0
	fi

	tmux::create_session "$session_name" "$directory"

	project_script="$directory/.muxxer/tmux-script.sh"
	fallback_script="$MUXXER_CONFIG_DIR/tmux-script.sh"
	session_script="$fallback_script"

	if [[ -f "$project_script" ]]; then
		session_script="$project_script"
	fi

	if [[ ! -f "$session_script" ]]; then
		log::error "No tmux script found (expected '$project_script' or '$fallback_script')"
		return 1
	fi

	tmux::send_command "$session_name" "bash \"$session_script\""
	log::success "Created tmux session '$session_name'"
}

workflow::local::run() {
	local session_name="${1:-}"
	local directory="${2:-}"

	if [[ -z "$session_name" || -z "$directory" ]]; then
		log::error "Usage: workflow::local::run <session_name> <directory>"
		return 1
	fi

	log::info "Preparing local workflow in '$directory'"
	workflow::local::setup_project_layout "$directory" || return 1
	workflow::local::create_session "$session_name" "$directory" || return 1
	log::info "Attaching to session '$session_name'"
	tmux::attach "$session_name"
}
