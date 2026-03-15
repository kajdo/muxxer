# New repository workflow module (Phase 4 placeholder).

workflow::newrepo::run() {
	local session_name="${1:-}"
	local repo_name="${1:-}"
	local template_name=""
	local repo_path=""
	local should_create_github=""
	local github_visibility="${MUXXER_GITHUB_DEFAULT_VISIBILITY:-private}"
	local github_owner=""
	local github_repo_full_name=""
	local prompt_suffix="[y/N]"
	local readme_created=0
	local shell_nix_created=0

	if [[ -z "$repo_name" ]]; then
		read -r -p "Repository name: " repo_name
	fi

	if [[ -z "$repo_name" ]]; then
		log::error "Repository name is required"
		return 1
	fi

	if [[ -z "$session_name" ]]; then
		session_name="$repo_name"
	fi

	template_name="$(fzf::select_language)"
	if [[ -z "$template_name" && "${MUXXER_CREATE_SHELL_NIX:-true}" == "true" ]]; then
		log::error "No shell template selected"
		return 1
	fi

	workflow::newrepo::create_directory "$repo_name" || return 1
	repo_path="$MUXXER_GIT_DIR/$repo_name"

	if [[ "${MUXXER_CREATE_SHELL_NIX:-true}" == "true" ]]; then
		if ! templates::copy "$template_name" "$repo_path"; then
			log::error "Failed to copy shell.nix template: $template_name"
			return 1
		fi

		log::success "Created shell.nix from '$template_name' template"
		shell_nix_created=1
	fi

	if [[ "${MUXXER_CREATE_README:-true}" == "true" ]]; then
		if ! templates::generate_readme "$repo_name" "$repo_path"; then
			log::error "Failed to generate README.md"
			return 1
		fi

		log::success "Generated README.md"
		readme_created=1
	fi

	if [[ "${MUXXER_INIT_GIT:-true}" == "true" ]]; then
		if ! git -C "$repo_path" add -A; then
			log::error "Failed to stage initial files"
			return 1
		fi

		if ((shell_nix_created == 1 || readme_created == 1)); then
			if ! git -C "$repo_path" commit -m "Initial commit" &>/dev/null; then
				log::error "Failed to create initial git commit"
				return 1
			fi

			log::success "Created initial git commit"
		else
			log::warning "Skipping initial commit: no files were generated"
		fi
	fi

	if [[ "${MUXXER_CREATE_GITHUB_REPO:-true}" == "true" ]]; then
		prompt_suffix="[Y/n]"
	fi

	read -r -p "Create GitHub repository for '$repo_name'? $prompt_suffix " should_create_github

	if [[ -z "$should_create_github" ]]; then
		should_create_github="${MUXXER_CREATE_GITHUB_REPO:-true}"
	fi

	if [[ "$should_create_github" =~ ^([Yy]|[Yy][Ee][Ss]|true)$ ]]; then
		workflow::newrepo::check_github_auth || return 1

		if ! github_owner="$(gh api user --jq .login 2>/dev/null)" || [[ -z "$github_owner" ]]; then
			log::error "Failed to detect authenticated GitHub username"
			return 1
		fi

		github_repo_full_name="$github_owner/$repo_name"
		if workflow::newrepo::repo_exists_on_github "$github_repo_full_name"; then
			log::error "GitHub repository already exists: $github_repo_full_name"
			return 1
		fi

		if [[ "$github_visibility" != "public" && "$github_visibility" != "private" ]]; then
			log::warning "Invalid MUXXER_GITHUB_DEFAULT_VISIBILITY '$github_visibility', using 'private'"
			github_visibility="private"
		fi

		if ! gh repo create "$github_repo_full_name" --"$github_visibility" --source "$repo_path" --remote origin; then
			log::error "Failed to create GitHub repository: $github_repo_full_name"
			return 1
		fi

		log::success "Created GitHub repository: $github_repo_full_name"
	fi

	workflow::local::run "$session_name" "$repo_path"
}

workflow::newrepo::repo_exists_on_github() {
	local repo_name="${1:-}"

	if [[ -z "$repo_name" ]]; then
		log::error "Repository name is required"
		return 1
	fi

	if ! command -v gh &>/dev/null; then
		log::error "GitHub CLI (gh) is required to check repository existence"
		return 1
	fi

	gh repo view "$repo_name" &>/dev/null
	return $?
}

workflow::newrepo::clone_repo() {
	local repo_reference="${1:-}"
	local session_name="${2:-}"
	local clone_source=""
	local repo_name=""
	local repo_path=""

	if [[ -z "$repo_reference" ]]; then
		log::error "Repository URL or owner/repo is required"
		return 1
	fi

	if [[ -z "${MUXXER_GIT_DIR:-}" ]]; then
		log::error "MUXXER_GIT_DIR is not set"
		return 1
	fi

	if [[ "$repo_reference" =~ ^https?:// || "$repo_reference" =~ ^git@ ]]; then
		clone_source="$repo_reference"
	elif [[ "$repo_reference" == */* ]]; then
		clone_source="https://github.com/${repo_reference}.git"
	else
		log::error "Invalid repository reference: $repo_reference"
		return 1
	fi

	repo_name="${repo_reference##*/}"
	repo_name="${repo_name%.git}"
	repo_path="$MUXXER_GIT_DIR/$repo_name"

	if [[ -e "$repo_path" ]]; then
		log::error "Repository directory already exists: $repo_path"
		return 1
	fi

	mkdir -p "$MUXXER_GIT_DIR"

	if ! git -C "$MUXXER_GIT_DIR" clone "$clone_source" "$repo_name"; then
		log::error "Failed to clone repository: $repo_reference"
		return 1
	fi

	log::success "Cloned repository to $repo_path"

	if [[ -z "$session_name" ]]; then
		session_name="$repo_name"
	fi

	workflow::local::run "$session_name" "$repo_path"
}

workflow::newrepo::check_github_auth() {
	if ! command -v gh &>/dev/null; then
		log::error "GitHub CLI (gh) is required for new repo workflow"
		return 1
	fi

	if ! gh auth status &>/dev/null; then
		log::error "GitHub CLI is not authenticated. Run: gh auth login"
		return 1
	fi

	log::info "GitHub CLI authentication verified"
	return 0
}

workflow::newrepo::create_directory() {
	local repo_name="${1:-}"
	local repo_path=""

	if [[ -z "$repo_name" ]]; then
		log::error "Repository name is required"
		return 1
	fi

	if [[ -z "${MUXXER_GIT_DIR:-}" ]]; then
		log::error "MUXXER_GIT_DIR is not set"
		return 1
	fi

	repo_path="$MUXXER_GIT_DIR/$repo_name"

	if [[ -e "$repo_path" ]]; then
		log::error "Repository directory already exists: $repo_path"
		return 1
	fi

	mkdir -p "$repo_path"
	log::info "Created repository directory: $repo_path"

	if ! git -C "$repo_path" init &>/dev/null; then
		log::error "Failed to initialize git repository in: $repo_path"
		return 1
	fi

	log::info "Initialized git repository: $repo_path"
	return 0
}
