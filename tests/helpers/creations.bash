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
