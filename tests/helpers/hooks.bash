setup() {
  mkdir -p "${TARGET_DIR}"
  mkdir -p "${TEST_WORKING_DIR}"
  mkdir -p "${TEST_REPOS_DIR}"

  cd "${TEST_WORKING_DIR}"
  git init
  git remote add origin m2:/mms/decomposer-test.git
}

teardown() {
  rm -rf "${TEST_TMP_DIR}"
}
