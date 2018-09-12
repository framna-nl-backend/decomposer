load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the different cases where failures happen during libraries installation

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: non existing repository" {
  create_decomposer_json alpha_psr4 beta_psr0 gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  # don't create the beta-lib repository
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (cloning git repository failed)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: non existing tag" {
  create_decomposer_json alpha_psr4 beta_non_existing_tag gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local beta_lib_revision_hash="$( create_repository beta-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (revision '1.2.3' not found)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.2.3 Gamma-1.0
}

@test "${SUITE_NAME}: non existing branch" {
  create_decomposer_json alpha_psr4 beta_non_existing_branch gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local beta_lib_revision_hash="$( create_repository beta-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (revision 'foo' not found)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: non existing commit" {
  create_decomposer_json alpha_psr4 beta_non_existing_commit gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local beta_lib_revision_hash="$( create_repository beta-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (revision '301939ad0133ef' not found)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}
