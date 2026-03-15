# Colored logging helpers for consistent user-facing CLI output.

log::info() {
	echo -e "\033[0;34m[INFO]\033[0m $1"
}

log::success() {
	echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

log::error() {
	echo -e "\033[0;31m[ERROR]\033[0m $1" >&2
}

log::warning() {
	echo -e "\033[0;33m[WARNING]\033[0m $1"
}
