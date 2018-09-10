load helpers

# This suite tests the different cases where existing libraries should not be reset

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: already existing library as symlink" {
  local decomposer_json=$(
cat << EOF
{
    "Alpha": {
        "url": "${TEST_REPOS_DIR}/alpha-lib",
        "revision": "master",
        "version": "1.0",
        "psr4": {
            "prefix": "alpha-lib",
            "search-path": "/src/alpha/"
         }
     }
}
EOF
)
  create_decomposer_json "${decomposer_json}"

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
  [ "${lines[0]}" = "Installing Alpha...done" ]

  # assert there was no change to the library
  assert_lib_folder Alpha-1.0 "${custom_alpha_lib_revision_hash}"
}

@test "${SUITE_NAME}: already existing library as git worktree" {
  local decomposer_json=$(
cat << EOF
{
    "Alpha": {
        "url": "${TEST_REPOS_DIR}/alpha-lib",
        "revision": "master",
        "version": "1.0",
        "psr4": {
            "prefix": "alpha-lib",
            "search-path": "/src/alpha/"
         }
     }
}
EOF
)
  create_decomposer_json "${decomposer_json}"

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
  [ "${lines[0]}" = "Installing Alpha...done" ]

  # assert there was no change to the library
  assert_lib_folder Alpha-1.0 "${custom_alpha_lib_revision_hash}"
}
