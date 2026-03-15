# Input validation helpers for filesystem paths, commands, and session names.

validation::directory_exists() {
	local path="$1"
	[[ -d "$path" ]]
}

validation::file_exists() {
	local path="$1"
	[[ -f "$path" ]]
}

validation::command_exists() {
	local command_name="$1"
	command -v "$command_name" &>/dev/null
}

validation::github_auth_check() {
	if ! command -v gh &>/dev/null; then
		return 1
	fi

	if ! gh auth status &>/dev/null; then
		return 1
	fi

	return 0
}

validation::require_command() {
	local command_name="$1"
	local error_message="$2"

	if ! validation::command_exists "$command_name"; then
		log::error "$error_message"
		exit 1
	fi

	return 0
}

validation::session_name_valid() {
	local session_name="$1"
	[[ "$session_name" =~ ^[[:alnum:]_\.:.-]+$ ]]
}
