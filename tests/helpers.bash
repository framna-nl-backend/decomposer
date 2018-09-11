# custom temporary test directory to prevent conflicts
export TEST_TMP_DIR="${BATS_TMPDIR}/decomposer"

# environment variables used by the tests only
export TEST_WORKING_DIR="${TEST_TMP_DIR}/working_dir"
export TEST_REPOS_DIR="${TEST_TMP_DIR}/repositories"
export TEST_FIXTURES_DIR="${BATS_TEST_DIRNAME}/fixtures"
export TEST_DECOMPOSER_PATH="${BATS_TEST_DIRNAME}/../decomposer"

# environment variables used by decomposer internally
export TARGET_DIR="${TEST_TMP_DIR}/libs"

setup() {
  mkdir -p "${TARGET_DIR}"
  mkdir -p "${TEST_WORKING_DIR}"
  mkdir -p "${TEST_REPOS_DIR}"

  cd "${TEST_WORKING_DIR}"
}

teardown() {
  rm -rf "${TEST_TMP_DIR}"
}

run_decomposer() {
  run "${TEST_DECOMPOSER_PATH}" "$@"
}

md5checksum_decomposer_json() {
  local file="${TEST_WORKING_DIR}/decomposer.json"

  case "$( uname )" in
    'Linux')
      md5sum "${file}" | cut -f1 -d' '
      ;;
    'Darwin')
      md5 -q "${file}"
      ;;
  esac
}

test_suite_name() {
  local test_file="${BATS_TEST_FILENAME##*/}"
  local test_filename="${test_file%.*}"
  local suite_name=$( printf "${test_filename}" | tr _ ' ' )

  printf "${suite_name}"
}

create_decomposer_json() {
  local fixture_name="$1"

  eval "cat << EOF
$(< "${TEST_FIXTURES_DIR}/decomposer_json/${fixture_name}.json" )
EOF" > "${TEST_WORKING_DIR}/decomposer.json"
}

create_repository() {
  local repo_name="$1"

  {
    git init "${TEST_REPOS_DIR}/${repo_name}"
    git -C "${TEST_REPOS_DIR}/${repo_name}" commit \
      --allow-empty --message 'commit 1'
  } > /dev/null

  local revision_hash=$(
    git -C "${TEST_REPOS_DIR}/${repo_name}" \
      rev-parse HEAD
  )

  printf "${revision_hash}"
}

assert_lib_installed() {
  local lib_name_version="$1"
  local expected_head_hash="$2"

  [ -d "${TARGET_DIR}/${lib_name_version}" ]

  local result_head_hash=$(
    git -C "${TARGET_DIR}/${lib_name_version}" \
      rev-parse --verify HEAD
  )

  [ "${expected_head_hash}" == "${result_head_hash}" ]
}

assert_lib_autoload_file() {
  local lib_name_version="$1"
  local fixture_name="$2"

  [ -f "${TARGET_DIR}/${lib_name_version}.php" ]

  local expected_content=$(
    cat "${TEST_FIXTURES_DIR}/autoload_lib/${fixture_name}.php"
  )

  local result_content=$(
    cat "${TARGET_DIR}/${lib_name_version}.php"
  )

  [ "${expected_content}" == "${result_content}" ]
}

assert_project_autoload_file() {
  local lib_name_version="$1"

  [ -f "${TEST_WORKING_DIR}/decomposer.autoload.inc.php" ]

  local expected_content=$(
    cat << EOF
<?php

require_once '${lib_name_version}.php';

?>
EOF
  )

  local result_content=$(
    cat "${TEST_WORKING_DIR}/decomposer.autoload.inc.php"
  )

  [ "${expected_content}" == "${result_content}" ]
}

assert_project_autoload_develop_file() {
  local lib_name_version="$1"

  [ -f "${TEST_WORKING_DIR}/decomposer.autoload.inc.php" ]

  local expected_content=$(
    cat << EOF
<?php

if (md5_file(__DIR__ . '/decomposer.json') != '$( md5checksum_decomposer_json )')
{
    die("Decomposer autoload file is outdated. Please re-run 'decomposer develop'
");
}

require_once '${lib_name_version}.php';

?>
EOF
  )

  local result_content=$(
    cat "${TEST_WORKING_DIR}/decomposer.autoload.inc.php"
  )

  [ "${expected_content}" == "${result_content}" ]
}
