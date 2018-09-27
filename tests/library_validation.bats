load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the different cases where a library definition is invalid

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: not an object" {
  create_decomposer_json alpha_psr4 beta_not_object gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: not an object)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  # not Beta because version is missing
  assert_project_autoload_file Alpha-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: missing url" {
  create_decomposer_json alpha_psr4 beta_missing_url gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid url)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: url not a string" {
  create_decomposer_json alpha_psr4 beta_url_not_string gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid url)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: missing version" {
  create_decomposer_json alpha_psr4 beta_missing_version gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid version)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  # not Beta because version is missing
  assert_project_autoload_file Alpha-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: version not a string" {
  create_decomposer_json alpha_psr4 beta_version_not_string gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid version)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  # not Beta because version is missing
  assert_project_autoload_file Alpha-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: revision not a string" {
  create_decomposer_json alpha_psr4 beta_revision_not_string gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid revision)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: target-dir not a string" {
  create_decomposer_json alpha_psr4 beta_target_dir_not_string gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid target-dir)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: missing psr0 or psr4" {
  create_decomposer_json alpha_psr4 beta_missing_psr gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: missing psr0 or psr4)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: conflicting psr0 and psr4" {
  create_decomposer_json alpha_psr4 beta_conflicting_psr gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: conflicting psr0 and psr4)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: psr0 is missing path" {
  create_decomposer_json alpha_psr4 beta_psr0_missing_path gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid psr0)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: psr0 path not a string" {
  create_decomposer_json alpha_psr4 beta_psr0_path_not_string gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid psr0)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: psr4 is missing prefix" {
  create_decomposer_json alpha_psr4 beta_psr4_missing_prefix gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid psr4)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: psr4 prefix not a string" {
  create_decomposer_json alpha_psr4 beta_psr4_prefix_not_string gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid psr4)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: psr4 is missing search-path" {
  create_decomposer_json alpha_psr4 beta_psr4_missing_search_path gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid psr4)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: psr4 search-path not a string" {
  create_decomposer_json alpha_psr4 beta_psr4_search_path_not_string gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha...done" ]
  [ "${lines[1]}" = "Installing Beta...failed (invalid definition: invalid psr4)" ]
  [ "${lines[2]}" = "Installing Gamma...done" ]

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}
