load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations

# This suite tests the validation of inputs

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: missing command" {
  run_decomposer
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: Missing command" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: invalid command" {
  run_decomposer xxx
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: Invalid command" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: install without decomposer.json" {
  run_decomposer install
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: No decomposer.json found." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: target directory doesn't exist" {
  create_decomposer_json alpha_psr4

  export TARGET_DIR='/xxx'

  run_decomposer install
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: TARGET_DIR '/xxx' is not a writable directory." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: target directory is a file" {
  create_decomposer_json alpha_psr4

  export TARGET_DIR="${TEST_TMP_DIR}/file"
  touch "${TEST_TMP_DIR}/file"

  run_decomposer install
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: TARGET_DIR '${TEST_TMP_DIR}/file' is not a writable directory." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: target directory is not writable" {
  create_decomposer_json alpha_psr4

  chmod -w "${TARGET_DIR}"

  run_decomposer install
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: TARGET_DIR '${TARGET_DIR}' is not a writable directory." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: decomposer.json doesn't contain JSON content" {
  create_decomposer_json not_json_content

  run_decomposer install
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: decomposer.json is not a valid JSON object" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: decomposer.json doesn't contain JSON object" {
  create_decomposer_json not_json_object

  run_decomposer install
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: decomposer.json is not a valid JSON object" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: changelog pointing to inaccessible location" {
  create_decomposer_json alpha_psr4

  run_decomposer install --changelog '/root/changelog.fail'
  [ "${status}" -eq 1 ]
  echo ${lines[0]}
  [ "${lines[0]}" = "decomposer: Changelog file '/root/changelog.fail' is not writable." ]

  [[ ! -f "/root/changelog.fail" ]]
}

@test "${SUITE_NAME}: changelog pointing to inaccessible file" {
  create_decomposer_json alpha_psr4

  touch "${TEST_WORKING_DIR}/decomposer.diffnotes.md"
  chmod -w "${TEST_WORKING_DIR}/decomposer.diffnotes.md"

  run_decomposer install --changelog "${TEST_WORKING_DIR}/decomposer.diffnotes.md"
  [ "${status}" -eq 1 ]

  local error_msg="decomposer: Changelog file '${TEST_WORKING_DIR}/decomposer.diffnotes.md' is not writable."
  [ "${lines[0]}" = "${error_msg}" ]
}
