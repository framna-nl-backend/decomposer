load helpers

# This suite tests the "install" command

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: single new PSR4 lib" {
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

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_folder Alpha-1.0 "${alpha_lib_revision_hash}"

  local expected_alpha_lib_file=$(
cat << EOF
<?php

autoload_register_psr4_prefix('alpha-lib', 'Alpha-1.0/src/alpha/');

?>
EOF
)
  assert_lib_file Alpha-1.0 "${expected_alpha_lib_file}"

  local expected_autoload_file=$(
cat << EOF
<?php

require_once 'Alpha-1.0.php';

?>
EOF
)
  assert_autoload_file "${expected_autoload_file}"
}

@test "${SUITE_NAME}: single new PSR0 lib" {
  local decomposer_json=$(
cat << EOF
{
    "Alpha": {
        "url": "${TEST_REPOS_DIR}/alpha-lib",
        "revision": "master",
        "version": "1.0",
        "psr0": {
            "path": "/src/alpha/"
         }
     }
}
EOF
)
  create_decomposer_json "${decomposer_json}"

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_folder Alpha-1.0 "${alpha_lib_revision_hash}"

  local expected_alpha_lib_file=$(
cat << EOF
<?php

set_include_path(
    get_include_path() . ':' .
    __DIR__ . '/Alpha-1.0/src/alpha/'
);

?>
EOF
)
  assert_lib_file Alpha-1.0 "${expected_alpha_lib_file}"

  local expected_autoload_file=$(
cat << EOF
<?php

require_once 'Alpha-1.0.php';

?>
EOF
)
  assert_autoload_file "${expected_autoload_file}"
}
