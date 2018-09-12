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
  local lib_name_versions="$@"

  [ -f "${TEST_WORKING_DIR}/decomposer.autoload.inc.php" ]

  local expected_content=$(
    printf '<?php\n\n';
    for lib_name_version in ${lib_name_versions}; do
      printf "require_once '%s.php';\\n" "${lib_name_version}"
    done;
    printf '\n?>\n';
  )

  local result_content=$(
    cat "${TEST_WORKING_DIR}/decomposer.autoload.inc.php"
  )

  [ "${expected_content}" == "${result_content}" ]
}

assert_project_autoload_develop_file() {
  local lib_name_versions="$@"

  [ -f "${TEST_WORKING_DIR}/decomposer.autoload.inc.php" ]

  local expected_content=$(
    cat << EOF
<?php

if (md5_file(__DIR__ . '/decomposer.json') != '$( md5checksum_decomposer_json )')
{
    die("Decomposer autoload file is outdated. Please re-run 'decomposer develop'
");
}
EOF
  )

  expected_content+="$(
    printf '\n\n';
    for lib_name_version in ${lib_name_versions}; do
      printf "require_once '%s.php';\\n" "${lib_name_version}"
    done;
    printf '\n?>\n';
  )"

  local result_content=$(
    cat "${TEST_WORKING_DIR}/decomposer.autoload.inc.php"
  )

  [ "${expected_content}" == "${result_content}" ]
}
