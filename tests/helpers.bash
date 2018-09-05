# environment variables used by decomposer internally
export TARGET_DIR="${BATS_TMPDIR}/libs"

# environment variables used by the tests only
export TEST_WORKING_DIR="${BATS_TMPDIR}/working_dir"
export TEST_REPOS_DIR="${BATS_TMPDIR}/repositories"
export TEST_DECOMPOSER_PATH="${BATS_TEST_DIRNAME}/../decomposer"

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
  run "${TEST_DECOMPOSER_PATH}" "$@"
}

create_decomposer_json() {
  local content="$1"

  echo "${content}" > "${TEST_WORKING_DIR}/decomposer.json"
}

create_repository() {
  local name="$1"

  {
    git init "${TEST_REPOS_DIR}/${name}"
    git -C "${TEST_REPOS_DIR}/${name}" commit \
      --allow-empty --message 'commit 1'
  } > /dev/null

  REVISION_HASH=$(
    git -C "${TEST_REPOS_DIR}/${name}" \
      rev-parse HEAD
  )
}

assert_lib_folder() {
  local name="$1"
  local expected_head_type="$2"
  local expected_head_hash="$3"

  [ -d "${TARGET_DIR}/${name}" ]

  local result_head_hash=$(
    git -C "${TARGET_DIR}/${name}" \
      rev-parse --verify \
      "HEAD^{${expected_head_type}}"
  )

  [ "${expected_head_hash}" == "${result_head_hash}" ]
}

assert_lib_file() {
  local name="$1"
  local expected_content="$2"

  [ -f "${TARGET_DIR}/${name}.php" ]

  local result_content=$(
    cat "${TARGET_DIR}/${name}.php"
  )

  [ "${expected_content}" == "${result_content}" ]
}

assert_autoload_file() {
  local expected_content="$1"

  [ -f "${TEST_WORKING_DIR}/decomposer.autoload.inc.php" ]

  local result_content=$(
    cat "${TEST_WORKING_DIR}/decomposer.autoload.inc.php"
  )

  [ "${expected_content}" == "${result_content}" ]
}
