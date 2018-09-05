export TEST_WORKING_DIR="${BATS_TMPDIR}/working_dir"

export TEST_REPOS_DIR="${BATS_TMPDIR}/repositories"

export TARGET_DIR="${BATS_TMPDIR}/libs"

export DECOMPOSER_PATH="${BATS_TEST_DIRNAME}/../decomposer"

setup() {
  mkdir -p "${TARGET_DIR}"
  mkdir -p "${TEST_WORKING_DIR}"
  mkdir -p "${TEST_REPOS_DIR}"

  cd "${TEST_WORKING_DIR}"
}

teardown() {
  rm -rf "${TARGET_DIR}"
  rm -rf "${TEST_WORKING_DIR}"
  rm -rf "${TEST_REPOS_DIR}"
}

run_decomposer() {
  run "${DECOMPOSER_PATH}" "$@"
}
