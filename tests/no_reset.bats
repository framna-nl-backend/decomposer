load helpers

# This suite tests the different cases where existing libraries should not be reset

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: already existing library as symlink" {
  local decomposer_json=$(
cat << EOF
{
    "Library_1": {
        "url": "${TEST_REPOS_DIR}/lib1",
        "revision": "master",
        "version": "1.0",
        "psr4": {
            "prefix": "lib1",
            "search-path": "/src/Lib1/"
         }
     }
}
EOF
)
  create_decomposer_json "${decomposer_json}"

  create_repository lib1

   # create clone of library
   git clone "${TEST_REPOS_DIR}/lib1" "${TEST_TMP_DIR}/Library_1"
   # add some local modifications
   git -C "${TEST_TMP_DIR}/Library_1" commit \
     --allow-empty --message 'custom commit'
   # create symlink in target folder with version
   ln -s "${TEST_TMP_DIR}/Library_1" "${TARGET_DIR}/Library_1-1.0"

  local custom_lib1_revision_hash=$(
    git -C "${TARGET_DIR}/Library_1-1.0" \
      rev-parse HEAD
  )

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Library_1...done" ]

  # assert there was no change to the library
  assert_lib_folder Library_1-1.0 "${custom_lib1_revision_hash}"
}

@test "${SUITE_NAME}: already existing library as git worktree" {
  local decomposer_json=$(
cat << EOF
{
    "Library_1": {
        "url": "${TEST_REPOS_DIR}/lib1",
        "revision": "master",
        "version": "1.0",
        "psr4": {
            "prefix": "lib1",
            "search-path": "/src/Lib1/"
         }
     }
}
EOF
)
  create_decomposer_json "${decomposer_json}"

  create_repository lib1

  # create clone of library
  git clone "${TEST_REPOS_DIR}/lib1" "${TEST_TMP_DIR}/Library_1"
  # create worktree in target folder with version
  git -C "${TEST_TMP_DIR}/Library_1" worktree \
    add "${TARGET_DIR}/Library_1-1.0"
  # add some local modifications in that worktree
  git -C "${TARGET_DIR}/Library_1-1.0" commit \
    --allow-empty --message 'custom commit'

  local custom_lib1_revision_hash=$(
    git -C "${TARGET_DIR}/Library_1-1.0" \
      rev-parse HEAD
  )

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Library_1...done" ]

  # assert there was no change to the library
  assert_lib_folder Library_1-1.0 "${custom_lib1_revision_hash}"
}
