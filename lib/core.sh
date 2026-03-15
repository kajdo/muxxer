#!/usr/bin/env bash

# Core muxxer module: defines shared constants and loader helpers.

# shellcheck disable=SC2034
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"
DEFAULTS_DIR="$SCRIPT_DIR/defaults"
MUXXER_VERSION="0.1.0"

export SCRIPT_DIR LIB_DIR DEFAULTS_DIR MUXXER_VERSION

core::enable_strict_mode() {
	set -euo pipefail
}

core::require() {
	# shellcheck disable=SC1090
	source "$LIB_DIR/$1"
}

# shellcheck disable=SC2034
RESET='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'

export RESET RED GREEN YELLOW BLUE
