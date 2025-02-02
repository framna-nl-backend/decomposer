load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the "install" command with the --no-dev option

BATS_TEST_NAME_PREFIX="$( test_suite_name ): "

@test "single new PSR-4 library" {
  create_decomposer_json alpha_psr4

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  run_decomposer install --no-dev
  assert_success
  assert_output "Installing Alpha...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4

  assert_project_autoload_file_without_check Alpha-1.0
}

@test "single new PSR-0 library" {
  create_decomposer_json beta_psr0

  local beta_lib_revision_hash="$( create_repository beta-lib )"

  run_decomposer install --no-dev
  assert_success
  assert_output "Installing Beta...done"

  assert_lib_installed Beta-1.0 "${beta_lib_revision_hash}"

  assert_lib_autoload_file Beta-1.0 beta_psr0

  assert_project_autoload_file_without_check Beta-1.0
}

@test "multiple new libraries" {
  create_decomposer_json alpha_psr4 beta_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local beta_lib_revision_hash="$( create_repository beta-lib )"

  run_decomposer install --no-dev
  assert_success
  assert_line "Installing Alpha...done"
  assert_line "Installing Beta...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Beta-1.0 "${beta_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Beta-1.0 beta_psr0

  assert_project_autoload_file_without_check Alpha-1.0 Beta-1.0
}

@test "single new PSR-4 library (not development-only)" {
  create_decomposer_json alpha_nodev

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  run_decomposer install --no-dev
  assert_success
  assert_output "Installing Alpha...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4

  assert_project_autoload_file_without_check Alpha-1.0
}

@test "single new PSR-4 library (development-only)" {
  create_decomposer_json alpha_dev

  run_decomposer install --no-dev
  assert_success
  assert_output "Installing Alpha...skipped (development-only dependency)"

  assert_lib_not_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  assert_lib_no_autoload_file Alpha-1.0

  assert_project_autoload_file_without_check Alpha-1.0
}
