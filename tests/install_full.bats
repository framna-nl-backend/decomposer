load helpers

@test "install full: no decomposer.json" {
  run_decomposer install
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: No decomposer.json found." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "install full: single new lib" {
  cat << EOF > "${TEST_WORKING_DIR}/decomposer.json"
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

  {
    mkdir "${TEST_REPOS_DIR}/lib1"
    cd "${TEST_REPOS_DIR}/lib1"
    git init
    git commit --allow-empty --message 'commit 1'
    LIB1_COMMIT_HASH=$( git rev-parse HEAD )
    cd -
  } > /dev/null

  run_decomposer install
  [ "${status}" -eq 0 ]

  {
    [ -d "${TARGET_DIR}/Library_1-1.0" ]
    cd "${TARGET_DIR}/Library_1-1.0"
    [ $( git rev-parse --verify 'HEAD^{commit}' ) == "${LIB1_COMMIT_HASH}" ]
    cd -
  }

  [ -f "${TARGET_DIR}/Library_1-1.0.php" ]
  expected_lib1_php=$(
cat << EOF
<?php

autoload_register_psr4_prefix('lib1', 'Library_1-1.0/src/Lib1/');

?>
EOF
)
  result_lib1_php=$( cat "${TARGET_DIR}/Library_1-1.0.php" )
  [ "${expected_lib1_php}" == "${result_lib1_php}" ]

  [ -f "${TEST_WORKING_DIR}/decomposer.autoload.inc.php" ]
  expected_autoload_php=$(
cat << EOF
<?php

require_once 'Library_1-1.0.php';

?>
EOF
)
  result_autoload_php=$( cat "${TEST_WORKING_DIR}/decomposer.autoload.inc.php" )
  [ "${expected_autoload_php}" == "${result_autoload_php}" ]
}
