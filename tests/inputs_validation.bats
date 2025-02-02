bats_load_library bats-assert
bats_load_library bats-support

load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations

# This suite tests the validation of inputs

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: missing command" {
  run_decomposer
  assert_failure
  assert_line "decomposer: Missing command"
  assert_line "Try 'decomposer help' for more information."
}

@test "${SUITE_NAME}: invalid command" {
  run_decomposer xxx
  assert_failure
  assert_line "decomposer: Invalid command 'xxx'"
  assert_line "Try 'decomposer help' for more information."
}

@test "${SUITE_NAME}: install without decomposer.json" {
  run_decomposer install
  assert_failure
  assert_line "decomposer: No decomposer.json found."
  assert_line "Try 'decomposer help' for more information."
}

@test "${SUITE_NAME}: target directory doesn't exist" {
  create_decomposer_json alpha_psr4

  export DECOMPOSER_TARGET_DIR='/xxx'

  run_decomposer install
  assert_failure
  assert_line "decomposer: DECOMPOSER_TARGET_DIR '/xxx' is not a writable directory."
  assert_line "Try 'decomposer help' for more information."
}

@test "${SUITE_NAME}: target directory is a file" {
  create_decomposer_json alpha_psr4

  export DECOMPOSER_TARGET_DIR="${TEST_TMP_DIR}/file"
  touch "${TEST_TMP_DIR}/file"

  run_decomposer install
  assert_failure
  assert_line "decomposer: DECOMPOSER_TARGET_DIR '${TEST_TMP_DIR}/file' is not a writable directory."
  assert_line "Try 'decomposer help' for more information."
}

@test "${SUITE_NAME}: target directory is not writable" {
  create_decomposer_json alpha_psr4

  chmod -w "${DECOMPOSER_TARGET_DIR}"

  run_decomposer install
  assert_failure
  assert_line "decomposer: DECOMPOSER_TARGET_DIR '${DECOMPOSER_TARGET_DIR}' is not a writable directory."
  assert_line "Try 'decomposer help' for more information."
}
