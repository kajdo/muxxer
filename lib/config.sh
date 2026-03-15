# Configuration management module for muxxer first-run setup and read-only config loading.

MUXXER_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/muxxer"
MUXXER_CONFIG="$MUXXER_CONFIG_DIR/config"

DEFAULTS_DIR="${DEFAULTS_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/defaults}"

export MUXXER_CONFIG_DIR MUXXER_CONFIG

config::copy_defaults() {
	mkdir -p "$MUXXER_CONFIG_DIR"
	cp "$DEFAULTS_DIR/config" "$MUXXER_CONFIG"
	cp "$DEFAULTS_DIR/tmux-script.sh" "$MUXXER_CONFIG_DIR/tmux-script.sh"
	mkdir -p "$MUXXER_CONFIG_DIR/shell-templates"
	cp -R "$DEFAULTS_DIR/templates/." "$MUXXER_CONFIG_DIR/shell-templates/"
}

config::get() {
	local key="${1:-}"
	local default_value="${2:-}"
	local value="${!key:-}"

	if [[ -n "$value" ]]; then
		printf '%s\n' "$value"
	else
		printf '%s\n' "$default_value"
	fi
}

config::validate() {
	local known_keys=(
		MUXXER_GIT_DIR
		MUXXER_CREATE_SHELL_NIX
		MUXXER_CREATE_README
		MUXXER_INIT_GIT
		MUXXER_CREATE_GITHUB_REPO
		MUXXER_GITHUB_DEFAULT_VISIBILITY
	)
	local key=""
	local allowed_key=""
	local line=""
	local known="false"

	if [[ ! -d "$MUXXER_GIT_DIR" ]]; then
		log::warning "MUXXER_GIT_DIR does not exist: $MUXXER_GIT_DIR"
	fi

	case "$MUXXER_GITHUB_DEFAULT_VISIBILITY" in
	public | private) ;;
	*)
		log::warning "MUXXER_GITHUB_DEFAULT_VISIBILITY should be 'public' or 'private' (got: $MUXXER_GITHUB_DEFAULT_VISIBILITY)"
		;;
	esac

	case "$MUXXER_CREATE_GITHUB_REPO" in
	true | false) ;;
	*)
		log::warning "MUXXER_CREATE_GITHUB_REPO should be 'true' or 'false' (got: $MUXXER_CREATE_GITHUB_REPO)"
		;;
	esac

	if [[ -f "$MUXXER_CONFIG" ]]; then
		while IFS= read -r line || [[ -n "$line" ]]; do
			if [[ "$line" =~ ^[[:space:]]*# ]] || [[ "$line" =~ ^[[:space:]]*$ ]]; then
				continue
			fi

			if [[ "$line" =~ ^[[:space:]]*(export[[:space:]]+)?([A-Za-z_][A-Za-z0-9_]*)= ]]; then
				key="${BASH_REMATCH[2]}"
				known="false"

				for allowed_key in "${known_keys[@]}"; do
					if [[ "$key" == "$allowed_key" ]]; then
						known="true"
						break
					fi
				done

				if [[ "$known" == "false" ]]; then
					log::warning "Unknown config key: $key"
				fi
			fi
		done <"$MUXXER_CONFIG"
	fi

	return 0
}

config::init() {
	if [[ ! -f "$MUXXER_CONFIG" ]]; then
		config::copy_defaults
	fi

	# shellcheck disable=SC1090
	source "$MUXXER_CONFIG"

	MUXXER_GIT_DIR="${MUXXER_GIT_DIR:-$HOME/git}"
	MUXXER_CREATE_SHELL_NIX="${MUXXER_CREATE_SHELL_NIX:-true}"
	MUXXER_CREATE_README="${MUXXER_CREATE_README:-true}"
	MUXXER_INIT_GIT="${MUXXER_INIT_GIT:-true}"
	MUXXER_CREATE_GITHUB_REPO="${MUXXER_CREATE_GITHUB_REPO:-true}"
	MUXXER_GITHUB_DEFAULT_VISIBILITY="${MUXXER_GITHUB_DEFAULT_VISIBILITY:-private}"

	export \
		MUXXER_GIT_DIR \
		MUXXER_CREATE_SHELL_NIX \
		MUXXER_CREATE_README \
		MUXXER_INIT_GIT \
		MUXXER_CREATE_GITHUB_REPO \
		MUXXER_GITHUB_DEFAULT_VISIBILITY

	config::validate
}
