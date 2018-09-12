run_decomposer() {
  run "${TEST_DECOMPOSER_PATH}" "$@"
}

test_suite_name() {
  local test_file="${BATS_TEST_FILENAME##*/}"
  local test_filename="${test_file%.*}"
  local suite_name=$( printf "${test_filename}" | tr _ ' ' )

  printf "${suite_name}"
}
