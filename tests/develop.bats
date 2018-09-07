load helpers

# This suite tests the "develop" command

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: single new PSR4 lib" {
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

  local lib1_revision_hash="$( create_repository lib1 )"

  run_decomposer develop
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Library_1...done" ]

  assert_lib_folder Library_1-1.0 "${lib1_revision_hash}"

  local expected_lib1_file=$(
cat << EOF
<?php

autoload_register_psr4_prefix('lib1', 'Library_1-1.0/src/Lib1/');

?>
EOF
)
  assert_lib_file Library_1-1.0 "${expected_lib1_file}"

  local expected_autoload_file=$(
cat << EOF
<?php

if (md5_file(__DIR__ . '/decomposer.json') != '$( md5checksum_decomposer_json )')
{
    die("Decomposer autoload file is outdated. Please re-run 'decomposer develop'
");
}

require_once 'Library_1-1.0.php';

?>
EOF
)
  assert_autoload_file "${expected_autoload_file}"
}

@test "${SUITE_NAME}: single new PSR0 lib" {
  local decomposer_json=$(
cat << EOF
{
    "Library_1": {
        "url": "${TEST_REPOS_DIR}/lib1",
        "revision": "master",
        "version": "1.0",
        "psr0": {
            "path": "/src/Lib1/"
         }
     }
}
EOF
)
  create_decomposer_json "${decomposer_json}"

  local lib1_revision_hash="$( create_repository lib1 )"

  run_decomposer develop
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Library_1...done" ]

  assert_lib_folder Library_1-1.0 "${lib1_revision_hash}"

  local expected_lib1_file=$(
cat << EOF
<?php

set_include_path(
    get_include_path() . ':' .
    __DIR__ . '/Library_1-1.0/src/Lib1/'
);

?>
EOF
)
  assert_lib_file Library_1-1.0 "${expected_lib1_file}"

  local expected_autoload_file=$(
cat << EOF
<?php

if (md5_file(__DIR__ . '/decomposer.json') != '$( md5checksum_decomposer_json )')
{
    die("Decomposer autoload file is outdated. Please re-run 'decomposer develop'
");
}

require_once 'Library_1-1.0.php';

?>
EOF
)
  assert_autoload_file "${expected_autoload_file}"
}
