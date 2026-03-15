# Project directory validation helpers.

project::is_valid_directory() {
	local directory="$1"
	[[ -n "$directory" && -d "$directory" ]]
}

project::has_nix_shell() {
	local directory="$1"

	if ! project::is_valid_directory "$directory"; then
		return 1
	fi

	[[ -f "$directory/shell.nix" || -f "$directory/flake.nix" ]]
}
