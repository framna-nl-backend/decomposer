load helpers

# This suite tests the "develop" command

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: single new PSR4 lib" {
  create_decomposer_json alpha_psr4

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  run_decomposer develop
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_folder Alpha-1.0 "${alpha_lib_revision_hash}"

  assert_lib_file Alpha-1.0 alpha_psr4

  assert_autoload_develop_file Alpha-1.0
}

@test "${SUITE_NAME}: single new PSR0 lib" {
  create_decomposer_json beta_psr0

  local beta_lib_revision_hash="$( create_repository beta-lib )"

  run_decomposer develop
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Beta...done" ]

  assert_lib_folder Beta-1.0 "${beta_lib_revision_hash}"

  assert_lib_file Beta-1.0 beta_psr0

  assert_autoload_develop_file Beta-1.0
}
