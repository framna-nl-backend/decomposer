exit_error() {
  [[ -z "$1" ]] || printf '%s: %s\n' decomposer "$1"
  printf "Try '%s help' for more information.\\n" decomposer
  exit 1
} >&2
