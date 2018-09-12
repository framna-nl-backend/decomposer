setup() {
  mkdir -p "${TARGET_DIR}"
  mkdir -p "${TEST_WORKING_DIR}"
  mkdir -p "${TEST_REPOS_DIR}"

  cd "${TEST_WORKING_DIR}"
}

teardown() {
  rm -rf "${TEST_TMP_DIR}"
}
