# fzf selection interfaces module for muxxer directory, session, and template pickers.

fzf::pick() {
	local preview_cmd="${1:-}"

	fzf \
		--height 50% \
		--layout reverse \
		-i \
		--cycle \
		--preview "$preview_cmd" \
		--preview-window right:60% \
		--bind 'ctrl-c:abort'
}

fzf::preview_directory() {
	local directory="${1:-}"
	local readme_path=""

	if [[ "$directory" == "NEW REPO" ]]; then
		printf 'Create a new repository in %s.\n' "${MUXXER_GIT_DIR:-$HOME/git}"
		return 0
	fi

	if [[ -z "$directory" || ! -d "$directory" ]]; then
		printf 'Directory not available.\n'
		return 0
	fi

	readme_path="$directory/README.md"
	if [[ -f "$readme_path" ]]; then
		cat "$readme_path"
	else
		ls -la "$directory"
	fi
}

fzf::select_directory() {
	local session_name="${1:-}"
	local git_dir="${MUXXER_GIT_DIR:-$HOME/git}"
	local selected=""
	local dir=""
	local -a matches=()
	local -a entries=()
	local nocaseglob_was_set=0
	local nullglob_was_set=0

	if [[ ! -d "$git_dir" ]]; then
		printf '%s' ""
		return 0
	fi

	shopt -q nocaseglob && nocaseglob_was_set=1
	shopt -q nullglob && nullglob_was_set=1
	shopt -s nocaseglob nullglob
	matches=("$git_dir"/*"$session_name"*)
	((nocaseglob_was_set)) || shopt -u nocaseglob
	((nullglob_was_set)) || shopt -u nullglob

	for dir in "${matches[@]}"; do
		if [[ -d "$dir" ]]; then
			entries+=("$dir")
		fi
	done

	entries+=("NEW REPO")

	export -f fzf::preview_directory
	selected="$(printf '%s\n' "${entries[@]}" | fzf::pick "bash -c 'fzf::preview_directory \"\$1\"' _ {}")"

	if [[ -z "$selected" ]]; then
		printf '%s' ""
		return 0
	fi

	printf '%s\n' "$selected"
}

fzf::select_all_directories() {
	local git_dir="${MUXXER_GIT_DIR:-$HOME/git}"
	local selected=""
	local dir=""
	local -a entries=()

	if [[ ! -d "$git_dir" ]]; then
		printf '%s' ""
		return 0
	fi

	for dir in "$git_dir"/*; do
		if [[ -d "$dir" ]]; then
			entries+=("$dir")
		fi
	done

	if [[ ${#entries[@]} -eq 0 ]]; then
		printf '%s' ""
		return 0
	fi

	export -f fzf::preview_directory
	selected="$(printf '%s\n' "${entries[@]}" | fzf::pick "bash -c 'fzf::preview_directory \"\$1\"' _ {}")"

	if [[ -z "$selected" ]]; then
		printf '%s' ""
		return 0
	fi

	printf '%s\n' "$selected"
}

fzf::select_session() {
	local selected=""
	local line=""
	local session_name=""
	local details=""
	local window_count=""
	local -a entries=()

	while IFS= read -r line; do
		[[ -n "$line" ]] || continue
		session_name="${line%%:*}"
		details="${line#*: }"
		window_count="${details%% windows*}"
		entries+=("${session_name}|${window_count} windows")
	done < <(tmux ls 2>/dev/null)

	if [[ ${#entries[@]} -eq 0 ]]; then
		printf '%s' ""
		return 0
	fi

	selected="$(printf '%s\n' "${entries[@]}" | fzf::pick "bash -c 'line=\"\$1\"; session=\"\${line%%|*}\"; tmux list-windows -t \"\$session\" 2>/dev/null || printf \"Session not available.\\n\"' _ {}")"

	if [[ -z "$selected" ]]; then
		printf '%s' ""
		return 0
	fi

	printf '%s\n' "${selected%%|*}"
}

fzf::select_language() {
	local template_dir="${MUXXER_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/muxxer}/shell-templates"
	local template_path=""
	local selected=""
	local -a languages=()

	if [[ ! -d "$template_dir" ]]; then
		printf '%s' ""
		return 0
	fi

	for template_path in "$template_dir"/*.nix; do
		if [[ ! -f "$template_path" ]]; then
			continue
		fi

		languages+=("$(basename "$template_path" .nix)")
	done

	if [[ ${#languages[@]} -eq 0 ]]; then
		printf '%s' ""
		return 0
	fi

	selected="$(printf '%s\n' "${languages[@]}" | fzf::pick "bash -c 'template=\"\$1\"; dir=\"${template_dir}\"; file=\"\${dir}/\${template}.nix\"; if [[ -f \"\$file\" ]]; then cat \"\$file\"; else printf \"Template not found.\\n\"; fi' _ {}")"

	if [[ -z "$selected" ]]; then
		printf '%s' ""
		return 0
	fi

	printf '%s\n' "$selected"
}
