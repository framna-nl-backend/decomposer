load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the "install" command

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: existing library fetches new commits without log as default" {
  create_decomposer_json alpha_psr4

  create_repository alpha-lib

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  # create new commit in repository
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  local commit_alpha_lib_revision_hash=$(
    git -C "${TEST_REPOS_DIR}/alpha-lib" \
      rev-parse HEAD
  )

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ ! -a "${TEST_WORKING_DIR}/decomposer.diffnotes.md" ]
  assert_lib_installed Alpha-1.0 "${commit_alpha_lib_revision_hash}"
}

@test "${SUITE_NAME}: existing library fetches new commits and writes log" {
  create_decomposer_json alpha_psr4

  create_repository alpha-lib

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  # create new commit in repository
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  local commit_alpha_lib_revision_hash=$(
    git -C "${TEST_REPOS_DIR}/alpha-lib" \
      rev-parse HEAD
  )

  run_decomposer install --changelog
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_changelog_file decomposer.diffnotes.md changelog_default

  assert_lib_installed Alpha-1.0 "${commit_alpha_lib_revision_hash}"
}

@test "${SUITE_NAME}: existing library fetches new commits and writes custom log" {
  create_decomposer_json alpha_psr4

  create_repository alpha-lib

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  # create new commit in repository
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  local commit_alpha_lib_revision_hash=$(
    git -C "${TEST_REPOS_DIR}/alpha-lib" \
      rev-parse HEAD
  )

  run_decomposer install --changelog ${TEST_WORKING_DIR}/test.file
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_changelog_file test.file changelog_default

  assert_lib_installed Alpha-1.0 "${commit_alpha_lib_revision_hash}"
}

@test "${SUITE_NAME}: existing library fetches new commits and writes deleted log" {
  create_decomposer_json alpha_psr4

  create_repository alpha-lib

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  git -C "${TARGET_DIR}/Alpha-1.0" checkout -b new_branch

  # create new commit in repository
  git -C "${TARGET_DIR}/Alpha-1.0" commit \
    --allow-empty --message 'branched commit'

  run_decomposer install --changelog ${TEST_WORKING_DIR}/test.file
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_changelog_file test.file changelog_deleted
}
