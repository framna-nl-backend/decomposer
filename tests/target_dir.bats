load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the "target-dir" field feature

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: single new PSR4 lib" {
  create_decomposer_json alpha_psr4_target_dir

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed 'Alpha-1.0/Target' "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4_target_dir

  assert_project_autoload_file Alpha-1.0
}

@test "${SUITE_NAME}: single new PSR0 lib" {
  create_decomposer_json beta_psr0_target_dir

  local beta_lib_revision_hash="$( create_repository beta-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Beta...done" ]

  assert_lib_installed 'Beta-1.0/Target' "${beta_lib_revision_hash}"

  assert_lib_autoload_file Beta-1.0 beta_psr0_target_dir

  assert_project_autoload_file Beta-1.0
}
