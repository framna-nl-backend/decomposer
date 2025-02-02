load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the "target-dir" field feature

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: single new PSR-0 library" {
  create_decomposer_json beta_psr0_target_dir

  local beta_lib_revision_hash="$( create_repository beta-lib )"

  run_decomposer install
  assert_success
  assert_output "Installing Beta...done"

  assert_lib_installed 'Beta-1.0/Target' "${beta_lib_revision_hash}"

  assert_lib_autoload_file Beta-1.0 beta_psr0_target_dir

  assert_project_autoload_file Beta-1.0
}
