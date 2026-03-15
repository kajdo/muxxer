# Template operations module for listing and copying shell templates.

templates::list() {
	local template_dir="$MUXXER_CONFIG_DIR/shell-templates"
	local template_path=""

	if [[ ! -d "$template_dir" ]]; then
		return 0
	fi

	for template_path in "$template_dir"/*.nix; do
		if [[ ! -f "$template_path" ]]; then
			continue
		fi

		basename "$template_path" .nix
	done
}

templates::copy() {
	local template_name="${1:-}"
	local destination="${2:-}"
	local template_path="$MUXXER_CONFIG_DIR/shell-templates/${template_name}.nix"

	if [[ ! -f "$template_path" ]]; then
		echo "Template not found: $template_name" >&2
		return 1
	fi

	cp "$template_path" "$destination/shell.nix"
}

templates::generate_readme() {
	local repo_name="${1:-}"
	local destination="${2:-}"
	local readme_template="$MUXXER_CONFIG_DIR/shell-templates/README.md.template"

	if [[ ! -f "$readme_template" ]]; then
		echo "Template not found: README.md.template" >&2
		return 1
	fi

	sed "s/{repo_name}/$repo_name/g" "$readme_template" >"$destination/README.md"
}
