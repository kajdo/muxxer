# Local repository workflow module for preparing project layout and launching tmux sessions.

workflow::local::ensure_project_detection_loaded() {
	local detection_module="${LIB_DIR:-}/utils/project-detection.sh"

	if declare -F project::detect_type >/dev/null; then
		return 0
	fi

	if [[ -f "$detection_module" ]]; then
		source "$detection_module"
	fi
}

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
	local project_type="unknown"
	local main_command=""
	local test_command=""
	local escaped_project_type=""
	local escaped_main_command=""
	local escaped_test_command=""

	if [[ -z "$session_name" || -z "$directory" ]]; then
		log::error "Session name and directory are required"
		return 1
	fi

	if tmux::session_exists "$session_name"; then
		log::info "Session '$session_name' already exists"
		return 0
	fi

	workflow::local::ensure_project_detection_loaded

	if declare -F project::detect_type >/dev/null; then
		project_type="$(project::detect_type "$directory")"
	else
		log::warning "Project detection helpers unavailable; defaulting type to 'unknown'"
	fi

	if declare -F project::get_main_command >/dev/null; then
		main_command="$(project::get_main_command "$directory")"
	fi

	if declare -F project::get_test_command >/dev/null; then
		test_command="$(project::get_test_command "$directory")"
	fi

	log::info "Detected project type for session '$session_name': $project_type"

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

	printf -v escaped_project_type '%q' "$project_type"
	printf -v escaped_main_command '%q' "$main_command"
	printf -v escaped_test_command '%q' "$test_command"

	tmux::send_command "$session_name" "MUXXER_PROJECT_TYPE=$escaped_project_type MUXXER_MAIN_COMMAND=$escaped_main_command MUXXER_TEST_COMMAND=$escaped_test_command bash \"$session_script\""
	log::success "Created tmux session '$session_name'"
}

workflow::local::run() {
	local session_name="${1:-}"
	local directory="${2:-}"
	local detected_project_type="unknown"

	if [[ -z "$session_name" || -z "$directory" ]]; then
		log::error "Usage: workflow::local::run <session_name> <directory>"
		return 1
	fi

	workflow::local::ensure_project_detection_loaded

	if declare -F project::detect_type >/dev/null; then
		detected_project_type="$(project::detect_type "$directory")"
	else
		log::warning "Project detection helpers unavailable; defaulting type to 'unknown'"
	fi

	log::info "Preparing local workflow in '$directory'"
	log::info "Detected project type: $detected_project_type"
	workflow::local::setup_project_layout "$directory" || return 1
	workflow::local::create_session "$session_name" "$directory" || return 1
	log::info "Attaching to session '$session_name'"
	tmux::attach "$session_name"
}
