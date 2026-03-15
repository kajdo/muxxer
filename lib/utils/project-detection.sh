# Project detection helpers for inferring project type and default commands.

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

project::detect_type() {
	local directory="$1"

	if ! project::is_valid_directory "$directory"; then
		echo "unknown"
		return 0
	fi

	if [[ -f "$directory/package.json" ]]; then
		echo "node"
		return 0
	fi

	if [[ -f "$directory/requirements.txt" || -f "$directory/pyproject.toml" || -f "$directory/setup.py" ]]; then
		echo "python"
		return 0
	fi

	if [[ -f "$directory/Cargo.toml" ]]; then
		echo "rust"
		return 0
	fi

	if [[ -f "$directory/go.mod" ]]; then
		echo "go"
		return 0
	fi

	if [[ -f "$directory/pubspec.yaml" ]]; then
		echo "flutter"
		return 0
	fi

	if project::has_nix_shell "$directory"; then
		echo "nix"
		return 0
	fi

	echo "unknown"
}

project::get_main_command() {
	local directory="$1"
	local project_type

	project_type="$(project::detect_type "$directory")"

	case "$project_type" in
	node)
		echo "npm run dev"
		;;
	python)
		echo "python main.py"
		;;
	rust)
		echo "cargo run"
		;;
	go)
		echo "go run ."
		;;
	flutter)
		echo "flutter run"
		;;
	nix)
		echo "nix-shell"
		;;
	*)
		echo ""
		;;
	esac
}

project::get_test_command() {
	local directory="$1"
	local project_type

	project_type="$(project::detect_type "$directory")"

	case "$project_type" in
	node)
		echo "npm test"
		;;
	python)
		echo "pytest"
		;;
	rust)
		echo "cargo test"
		;;
	go)
		echo "go test ./..."
		;;
	flutter)
		echo "flutter test"
		;;
	*)
		echo ""
		;;
	esac
}

project::get_install_command() {
	local directory="$1"
	local project_type

	project_type="$(project::detect_type "$directory")"

	case "$project_type" in
	node)
		echo "npm install"
		;;
	python)
		echo "pip install"
		;;
	rust)
		echo "cargo build"
		;;
	go)
		echo "go build"
		;;
	*)
		echo ""
		;;
	esac
}
