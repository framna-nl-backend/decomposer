load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the "lock" command

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: new decomposer.json pointing to inaccessible location" {
  create_decomposer_json alpha_psr4

  run_decomposer lock --file '/root/changelog.fail'
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: File '/root/changelog.fail' is not writable." ]

  [[ ! -f "/root/changelog.fail" ]]
}

@test "${SUITE_NAME}: new decomposer.json pointing to non writable file" {
  create_decomposer_json alpha_psr4

  touch "${TEST_WORKING_DIR}/decomposer_new.json"
  chmod -w "${TEST_WORKING_DIR}/decomposer_new.json"

  run_decomposer lock --file "${TEST_WORKING_DIR}/decomposer_new.json"
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: File '${TEST_WORKING_DIR}/decomposer_new.json' is not writable." ]
}

@test "${SUITE_NAME}: no change if tag" {
  create_decomposer_json alpha_tag_version

  create_repository alpha-lib

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  # create new commit in repository
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  run_decomposer lock
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Locking Alpha...skipped (already locked)" ]

  assert_decomposer_file "${TEST_WORKING_DIR}/decomposer_new.json" alpha_tag_version
}

@test "${SUITE_NAME}: failed to fetch changes" {
  create_decomposer_json alpha_branch_revision

  create_repository alpha-lib

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  # remove repository
  rm -rf "${TEST_REPOS_DIR}/alpha-lib"

  run_decomposer lock
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Locking Alpha...failed (fetching changes failed)" ]
}

@test "${SUITE_NAME}: no change if annotated tag" {
  create_decomposer_json alpha_tag_revision

  create_repository alpha-lib

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  # create new commit in repository
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  run_decomposer lock
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Locking Alpha...skipped (already locked)" ]

  assert_decomposer_file "${TEST_WORKING_DIR}/decomposer_new.json" alpha_tag_revision
}

@test "${SUITE_NAME}: no change if commit" {
  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # create decomposer.json with current commit
  export TEST_REPOS_COMMIT="${alpha_lib_revision_hash}"
  create_decomposer_json alpha_commit_revision

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  # create new commit in repository
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  run_decomposer lock
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Locking Alpha...skipped (already locked)" ]

  assert_decomposer_file "${TEST_WORKING_DIR}/decomposer_new.json" alpha_commit_revision
}

@test "${SUITE_NAME}: branch replaced with commit" {
  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # create branch in repository
  git -C "${TEST_REPOS_DIR}/alpha-lib" checkout -b rc1
  export TEST_REPOS_COMMIT="${alpha_lib_revision_hash}"

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  # create decomposer.json with current commit
  create_decomposer_json alpha_branch_revision

  run_decomposer lock
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Locking Alpha...done" ]

  assert_decomposer_file "${TEST_WORKING_DIR}/decomposer_new.json" alpha_commit_revision
}

@test "${SUITE_NAME}: new branch replaced with commit" {
  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  # create usual clone of library
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"

  # create new branch in repository with new commit
  git -C "${TEST_REPOS_DIR}/alpha-lib" checkout -b rc1
  git -C "${TEST_REPOS_DIR}/alpha-lib" commit \
    --allow-empty --message 'extra commit'

  local commit_alpha_lib_revision_hash=$(
    git -C "${TEST_REPOS_DIR}/alpha-lib" \
      rev-parse HEAD
  )
  export TEST_REPOS_COMMIT="${commit_alpha_lib_revision_hash}"

  # create decomposer.json with current commit
  create_decomposer_json alpha_branch_revision

  run_decomposer lock
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Locking Alpha...done" ]

  assert_decomposer_file "${TEST_WORKING_DIR}/decomposer_new.json" alpha_commit_revision
}

@test "${SUITE_NAME}: multiple libraries" {
  create_decomposer_json alpha_tag_version beta_psr0

  create_repository alpha-lib
  create_repository beta-lib

  # create usual clone of libraries
  git clone "${TEST_REPOS_DIR}/alpha-lib" "${TARGET_DIR}/Alpha-1.0"
  git clone "${TEST_REPOS_DIR}/beta-lib" "${TARGET_DIR}/Beta-1.0"

  local commit_beta_lib_revision_hash=$(
    git -C "${TEST_REPOS_DIR}/beta-lib" \
      rev-parse HEAD
  )
  export TEST_REPOS_REVISION="${commit_beta_lib_revision_hash}"

  run_decomposer lock
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Locking Alpha...skipped (already locked)" ]
  [ "${lines[1]}" = "Locking Beta...done" ]

  assert_decomposer_file "${TEST_WORKING_DIR}/decomposer_new.json" alpha_tag_version beta_custom_revision
}
