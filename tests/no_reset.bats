load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the different cases where existing libraries should not be reset

BATS_TEST_NAME_PREFIX="$( test_suite_name ): "

@test "correct tag with non committed modifications" {
  create_decomposer_json alpha_tag_version

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # tag current HEAD
  git -C "${TEST_REPOS_DIR}/alpha-lib" tag 1.0
  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${DECOMPOSER_TARGET_DIR}/Alpha-1.0"
  # modify file
  echo change > "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  assert_success
  assert_output "Installing Alpha...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  # assert there was no change to the file
  assert_file_contains "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README" '^change$'
}

@test "correct alternative tag with non committed modifications" {
  create_decomposer_json alpha_tag_version

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # tag current HEAD
  git -C "${TEST_REPOS_DIR}/alpha-lib" tag v1.0
  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${DECOMPOSER_TARGET_DIR}/Alpha-1.0"
  # modify file
  echo change > "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  assert_success
  assert_output "Installing Alpha...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  # assert there was no change to the file
  assert_file_contains "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README" '^change$'
}

@test "correct annotated tag with non committed modifications" {
  create_decomposer_json alpha_tag_version

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # tag current HEAD
  git -C "${TEST_REPOS_DIR}/alpha-lib" tag 1.0 -a -m 'tag'
  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${DECOMPOSER_TARGET_DIR}/Alpha-1.0"
  # modify file
  echo change > "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  assert_success
  assert_output "Installing Alpha...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  # assert there was no change to the file
  assert_file_contains "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README" '^change$'
}

@test "correct alternative annotated tag with non committed modifications" {
  create_decomposer_json alpha_tag_version

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # tag current HEAD
  git -C "${TEST_REPOS_DIR}/alpha-lib" tag v1.0 -a -m 'tag'
  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${DECOMPOSER_TARGET_DIR}/Alpha-1.0"
  # modify file
  echo change > "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  assert_success
  assert_output "Installing Alpha...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  # assert there was no change to the file
  assert_file_contains "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README" '^change$'
}

@test "correct branch with non committed modifications" {
  create_decomposer_json alpha_branch_revision

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # create new branch
  git -C "${TEST_REPOS_DIR}/alpha-lib" checkout -b rc1
  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${DECOMPOSER_TARGET_DIR}/Alpha-1.0"
  # switch to new branch
  git -C "${DECOMPOSER_TARGET_DIR}/Alpha-1.0" checkout rc1
  # modify file
  echo change > "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  assert_success
  assert_output "Installing Alpha...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  # assert there was no change to the file
  assert_file_contains "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README" '^change$'
}

@test "correct commit with non committed modifications" {
  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # create decomposer.json with current commit
  export TEST_REPOS_COMMIT="${alpha_lib_revision_hash}"
  create_decomposer_json alpha_commit_revision

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${DECOMPOSER_TARGET_DIR}/Alpha-1.0"
  # modify file
  echo change > "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README"

  run_decomposer install
  assert_success
  assert_output "Installing Alpha...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  # assert there was no change to the file
  assert_file_contains "${DECOMPOSER_TARGET_DIR}/Alpha-1.0/README" '^change$'
}
