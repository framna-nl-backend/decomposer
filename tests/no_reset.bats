load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the different cases where existing libraries should not be reset

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: correct tag with non commited modifications" {
  create_decomposer_json alpha_tag_version

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # tag current HEAD
  git -C "${TEST_REPOS_DIR}/alpha-lib" tag 1.0
  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"
  # modify file
  echo change > "${TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  # assert there was no change to the file
  [ $( cat "${TARGET_DIR}/Alpha-1.0/README" ) = 'change' ]
}

@test "${SUITE_NAME}: correct branch with non commited modifications" {
  create_decomposer_json alpha_branch_revision

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # create new branch
  git -C "${TEST_REPOS_DIR}/alpha-lib" checkout -b rc1
  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"
  # switch to new branch
  git -C "${TARGET_DIR}/Alpha-1.0" checkout rc1
  # modify file
  echo change > "${TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  # assert there was no change to the file
  [ $( cat "${TARGET_DIR}/Alpha-1.0/README" ) = 'change' ]
}

@test "${SUITE_NAME}: correct commit with non commited modifications" {
  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # create decomposer.json with current commit
  export TEST_REPOS_COMMIT="${alpha_lib_revision_hash}"
  create_decomposer_json alpha_commit_revision

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"
  # modify file
  echo change > "${TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  # assert there was no change to the file
  [ $( cat "${TARGET_DIR}/Alpha-1.0/README" ) = 'change' ]
}
