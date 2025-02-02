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
  assert_success
  assert_line "Installing Alpha...done"
  assert_line "Installing Beta...failed (cloning git repository failed)"
  assert_line "Installing Gamma...done"

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
  assert_success
  assert_line "Installing Alpha...done"
  assert_line "Installing Beta...failed (revision '1.2.3' not found)"
  assert_line "Installing Gamma...done"

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
  assert_success
  assert_line "Installing Alpha...done"
  assert_line "Installing Beta...failed (revision 'foo' not found)"
  assert_line "Installing Gamma...done"

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
  assert_success
  assert_line "Installing Alpha...done"
  assert_line "Installing Beta...failed (revision '301939ad0133ef' not found)"
  assert_line "Installing Gamma...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: revision is a blob object" {
  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local beta_lib_revision_hash="$( create_repository beta-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  # create decomposer.json with existing blob revision
  export TEST_REPOS_REVISION=$(
    git -C "${TEST_REPOS_DIR}/beta-lib" rev-list --objects --all \
      | grep README \
      | cut -f 1 -d ' '
  )
  create_decomposer_json alpha_psr4 beta_custom_revision gamma_psr0

  run_decomposer install
  assert_success
  assert_line "Installing Alpha...done"
  assert_line "Installing Beta...failed (revision '${TEST_REPOS_REVISION}' not found)"
  assert_line "Installing Gamma...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: revision is a tree object" {
  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local beta_lib_revision_hash="$( create_repository beta-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  # create decomposer.json with existing tree revision
  export TEST_REPOS_REVISION=$(
    git -C "${TEST_REPOS_DIR}/beta-lib" rev-list --objects --all \
      | grep -vE "README|${beta_lib_revision_hash}" \
      | cut -f 1 -d ' '
  )
  create_decomposer_json alpha_psr4 beta_custom_revision gamma_psr0

  run_decomposer install
  assert_success
  assert_line "Installing Alpha...done"
  assert_line "Installing Beta...failed (revision '${TEST_REPOS_REVISION}' not found)"
  assert_line "Installing Gamma...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: fetching changes fails" {
  create_decomposer_json alpha_psr4 beta_psr0 gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local beta_lib_revision_hash="$( create_repository beta-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  # create usual clone of beta library
  git clone "${TEST_REPOS_DIR}/beta-lib" "${DECOMPOSER_TARGET_DIR}/Beta-1.0"
  # remove beta repository
  rm -rf "${TEST_REPOS_DIR}/beta-lib"

  run_decomposer install
  assert_success
  assert_line "Installing Alpha...done"
  assert_line "Installing Beta...failed (fetching changes failed)"
  assert_line "Installing Gamma...done"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}

@test "${SUITE_NAME}: resetting changes fails" {
  create_decomposer_json alpha_psr4 beta_psr0 gamma_psr0

  local alpha_lib_revision_hash="$( create_repository alpha-lib )"
  local beta_lib_revision_hash="$( create_repository beta-lib )"
  local gamma_lib_revision_hash="$( create_repository gamma-lib )"

  # create usual clone of beta library
  git clone "${TEST_REPOS_DIR}/beta-lib" "${DECOMPOSER_TARGET_DIR}/Beta-1.0"
  # create new commit in repository
  git -C "${TEST_REPOS_DIR}/beta-lib" commit \
    --allow-empty --message 'extra commit'
  # lock clone
  touch "${DECOMPOSER_TARGET_DIR}/Beta-1.0/.git/index.lock"

  run_decomposer install
  assert_success
  assert_line "Installing Alpha...done"
  assert_line "Installing Beta...failed (resetting changes failed)"
  assert_line "Installing Gamma...done"

  chmod +w "${DECOMPOSER_TARGET_DIR}/Beta-1.0/README"

  assert_lib_installed Alpha-1.0 "${alpha_lib_revision_hash}"
  assert_lib_installed Gamma-1.0 "${gamma_lib_revision_hash}"

  assert_lib_autoload_file Alpha-1.0 alpha_psr4
  assert_lib_autoload_file Gamma-1.0 gamma_psr0

  assert_project_autoload_file Alpha-1.0 Beta-1.0 Gamma-1.0
}
