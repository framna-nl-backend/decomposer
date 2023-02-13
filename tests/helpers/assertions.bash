md5checksum_decomposer_json() {
  local file="${TEST_WORKING_DIR}/decomposer.json"

  if command -v 'md5sum' >/dev/null; then
    md5sum "${file}" | cut -f1 -d' '
  elif command -v 'md5' >/dev/null; then
    md5 -q "${file}"
  fi
}

assert_lib_installed() {
  local lib_name_version="$1"
  local expected_head_hash="$2"

  [ -d "${DECOMPOSER_TARGET_DIR}/${lib_name_version}" ]

  local result_head_hash=$(
    git -C "${DECOMPOSER_TARGET_DIR}/${lib_name_version}" \
      rev-parse --verify HEAD
  )

  [ "${expected_head_hash}" == "${result_head_hash}" ]
}

assert_lib_not_installed() {
  local lib_name_version="$1"
  local expected_head_hash="$2"

  ! [ -d "${DECOMPOSER_TARGET_DIR}/${lib_name_version}" ]
}

assert_lib_contains() {
  local lib_name_version="$1"
  local revision="$2"

  [ -d "${DECOMPOSER_TARGET_DIR}/${lib_name_version}" ]

  local object_type=$(
    git -C "${DECOMPOSER_TARGET_DIR}/${lib_name_version}" \
      cat-file -t "${revision}" 2> /dev/null
  )

  [ -n "${object_type}" ]
}

assert_lib_autoload_file() {
  local lib_name_version="$1"
  local fixture_name="$2"

  [ -f "${DECOMPOSER_TARGET_DIR}/${lib_name_version}.php" ]

  local expected_content=$(
    cat "${TEST_FIXTURES_DIR}/autoload_lib/${fixture_name}.php"
  )

  local result_content=$(
    cat "${DECOMPOSER_TARGET_DIR}/${lib_name_version}.php"
  )

  [ "${expected_content}" == "${result_content}" ]
}

assert_lib_no_autoload_file() {
  local lib_name_version="$1"
  local fixture_name="$2"

  ! [ -f "${DECOMPOSER_TARGET_DIR}/${lib_name_version}.php" ]
}

assert_project_autoload_file_without_check() {
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

assert_changelog_file() {
  local changelog_file="$1"
  local fixture_name="$2"

  [ -f "${changelog_file}" ]

  local expected_content=$(
    cat "${TEST_FIXTURES_DIR}/changelog/${fixture_name}"
  )

  local result_content=$(
    cat "${changelog_file}"
  )

  if [ "${expected_content}" != "${result_content}" ]; then
    diff -u "${TEST_FIXTURES_DIR}/changelog/${fixture_name}" "${changelog_file}"
    return 1
  fi

  return 0
}

assert_project_autoload_file() {
  local lib_name_versions="$@"

  [ -f "${TEST_WORKING_DIR}/decomposer.autoload.inc.php" ]

  local expected_content=$(
    cat << EOF
<?php

if (md5_file(__DIR__ . '/decomposer.json') != '$( md5checksum_decomposer_json )')
{
    die("Decomposer autoload file is outdated. Please re-run 'decomposer install'");
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

assert_decomposer_file() {
  local decomposer_file="$1"
  shift
  local fixture_names="$@"

  [ -f "${decomposer_file}" ]

  local new_decomposer_file=$( mktemp )

  {
    printf '{'

    local lib_jsons=
    for fixture_name in ${fixture_names}; do
      lib_jsons+=",$(eval "cat << EOF
$(< "${TEST_FIXTURES_DIR}/decomposer_json/${fixture_name}.json" )
EOF"
)"
    done

    # ignore first comma
    printf '%s' "${lib_jsons:1}"

    printf '}'
  } > "${new_decomposer_file}"

  local expected_content=$(
    jq -c '' "${new_decomposer_file}"
  )

  local result_content=$(
    jq -c '' "${decomposer_file}"
  )

  if [ "${expected_content}" != "${result_content}" ]; then
    diff -u \
      <( jq '' "${new_decomposer_file}" ) \
      <( jq '' "${decomposer_file}" )
    return 1
  fi

  return 0
}
