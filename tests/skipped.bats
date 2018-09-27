load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the different cases where existing libraries should be skipped

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: existing library as symlink" {
  create_decomposer_json alpha_psr4

  create_repository alpha-lib

  # create clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TEST_TMP_DIR}/Alpha"
  # add some local modifications
  git -C "${TEST_TMP_DIR}/Alpha" commit \
    --allow-empty --message 'custom commit'
  # create symlink in target folder with version
  ln -s "${TEST_TMP_DIR}/Alpha" "${TARGET_DIR}/Alpha-1.0"

  local custom_alpha_lib_revision_hash=$(
    git -C "${TARGET_DIR}/Alpha-1.0" \
      rev-parse HEAD
  )

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...skipped (symlink)" ]

  # assert there was no change to the library
  assert_lib_installed Alpha-1.0 "${custom_alpha_lib_revision_hash}"
}

@test "${SUITE_NAME}: existing library as git worktree" {
  create_decomposer_json alpha_psr4

  create_repository alpha-lib

  # create clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TEST_TMP_DIR}/Alpha"
  # create worktree in target folder with version
  git -C "${TEST_TMP_DIR}/Alpha" worktree \
    add "${TARGET_DIR}/Alpha-1.0"
  # add some local modifications in that worktree
  git -C "${TARGET_DIR}/Alpha-1.0" commit \
    --allow-empty --message 'custom commit'

  local custom_alpha_lib_revision_hash=$(
    git -C "${TARGET_DIR}/Alpha-1.0" \
      rev-parse HEAD
  )

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...skipped (git worktree)" ]

  # assert there was no change to the library
  assert_lib_installed Alpha-1.0 "${custom_alpha_lib_revision_hash}"
}

@test "${SUITE_NAME}: existing library but not a git repository" {
  create_decomposer_json alpha_psr4

  create_repository alpha-lib

  # create library as package with custom file
  mkdir "${TARGET_DIR}/Alpha-1.0"
  echo change > "${TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...skipped (not a git repository)" ]

  # assert there was no change to the file
  [ $( cat "${TARGET_DIR}/Alpha-1.0/README" ) = 'change' ]
}
