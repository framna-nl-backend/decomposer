load helpers

# This suite tests the different possible version and revision usages

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: tag from version" {
  create_decomposer_json alpha_tag_version

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # tag current HEAD and add one more commit on top
  git -C "${TEST_REPOS_DIR}/alpha-lib" tag 1.0
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4

  assert_project_autoload_file Alpha-1.0
}

@test "${SUITE_NAME}: alternative tag from version" {
  create_decomposer_json alpha_tag_version

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # tag current HEAD and add one more commit on top
  git -C "${TEST_REPOS_DIR}/alpha-lib" tag v1.0
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4

  assert_project_autoload_file Alpha-1.0
}

@test "${SUITE_NAME}: tag from revision" {
  create_decomposer_json alpha_tag_revision

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # tag current HEAD and add one more commit on top
  git -C "${TEST_REPOS_DIR}/alpha-lib" tag alpha-lib-1.0
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4

  assert_project_autoload_file Alpha-1.0
}

@test "${SUITE_NAME}: branch from revision" {
  create_decomposer_json alpha_branch_revision

  create_repository alpha-lib

  # create new branch with new commit inside
  git -C "${TEST_REPOS_DIR}/alpha-lib" checkout -b rc1
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  local branch_alpha_lib_revision_hash=$(
    git -C "${TEST_REPOS_DIR}/alpha-lib" \
      rev-parse HEAD
  )

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed Alpha-1.0 "${branch_alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4

  assert_project_autoload_file Alpha-1.0
}

@test "${SUITE_NAME}: commit from revision" {
  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # create decomposer.json with current commit
  export TEST_REPOS_COMMIT="${alpha_lib_revision_hash}"
  create_decomposer_json alpha_commit_revision

  # create new commit on top
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4

  assert_project_autoload_file Alpha-1.0
}
