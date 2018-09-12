load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the "develop" command

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: single new PSR4 lib" {
  create_decomposer_json alpha_psr4

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  run_decomposer develop
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4

  assert_project_autoload_develop_file Alpha-1.0
}

@test "${SUITE_NAME}: single new PSR0 lib" {
  create_decomposer_json beta_psr0

  local beta_lib_revision_hash="$( create_repository beta-lib )"

  run_decomposer develop
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Beta...done" ]

  assert_lib_installed Beta-1.0 "${beta_lib_revision_hash}"

  assert_lib_autoload_file Beta-1.0 beta_psr0

  assert_project_autoload_develop_file Beta-1.0
}

@test "${SUITE_NAME}: multiple new libs" {
  create_decomposer_json alpha_psr4 beta_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local beta_lib_revision_hash="$( create_repository beta-lib )"

  run_decomposer develop
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Beta-1.0 "${beta_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Beta-1.0 beta_psr0

  assert_project_autoload_develop_file Alpha-1.0 Beta-1.0
}
