create_decomposer_json() {
  local fixture_names="$@"

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
  } > "${TEST_WORKING_DIR}/decomposer.json"
}

create_repository() {
  local repo_name="$1"

  {
    git init "${TEST_REPOS_DIR}/${repo_name}"
    echo "${repo_name}" > "${TEST_REPOS_DIR}/${repo_name}/README"
    git -C "${TEST_REPOS_DIR}/${repo_name}" add README
    git -C "${TEST_REPOS_DIR}/${repo_name}" commit --message 'commit 1'
  } > /dev/null

  local revision_hash=$(
    git -C "${TEST_REPOS_DIR}/${repo_name}" \
      rev-parse HEAD
  )

  printf "${revision_hash}"
}

create_lib_autoload_file() {
  local lib_name_version="$1"
  local fixture_name="$2"

  cp "${TEST_FIXTURES_DIR}/autoload_lib/${fixture_name}.php" "${TARGET_DIR}/${lib_name_version}.php"
}

create_project_autoload_file() {
  local lib_name_versions="$@"

  {
   printf '<?php\n\n';
    for lib_name_version in ${lib_name_versions}; do
      printf "require_once '%s.php';\\n" "${lib_name_version}"
    done;
    printf '\n?>\n';
  } > "${TEST_WORKING_DIR}/decomposer.autoload.inc.php"
}
