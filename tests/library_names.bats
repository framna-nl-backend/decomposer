load helpers/variables
load helpers/hooks
load helpers/main
load helpers/creations
load helpers/assertions

# This suite tests the naming of libraries

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: contains a dot" {
  create_decomposer_json alpha_dot

  local alpha_lib_revision_hash="$( create_repository alpha.lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha.Lib...done" ]

  assert_lib_installed Alpha.Lib-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha.Lib-1.0 alpha_dot

  assert_project_autoload_file Alpha.Lib-1.0
}

@test "${SUITE_NAME}: contains a minus" {
  create_decomposer_json alpha_minus

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha-Lib...done" ]

  assert_lib_installed Alpha-Lib-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha-Lib-1.0 alpha_minus

  assert_project_autoload_file Alpha-Lib-1.0
}

@test "${SUITE_NAME}: contains an underscore" {
  create_decomposer_json alpha_underscore

  local alpha_lib_revision_hash="$( create_repository alpha_lib )"

  run_decomposer install
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "Installing Alpha_Lib...done" ]

  assert_lib_installed Alpha_Lib-1.0 "${alpha_lib_revision_hash}"

  assert_lib_autoload_file Alpha_Lib-1.0 alpha_underscore

  assert_project_autoload_file Alpha_Lib-1.0
}
