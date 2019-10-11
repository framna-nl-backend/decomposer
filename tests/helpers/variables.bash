# custom temporary test directory to prevent conflicts
export TEST_TMP_DIR="${BATS_TMPDIR}/decomposer"

# environment variables used by the tests only
export TEST_WORKING_DIR="${TEST_TMP_DIR}/working_dir"
export TEST_REPOS_DIR="${TEST_TMP_DIR}/repositories"
export TEST_FIXTURES_DIR="${BATS_TEST_DIRNAME}/fixtures"
export TEST_DECOMPOSER_PATH="${BATS_TEST_DIRNAME}/../bin/decomposer"

# environment variables used by decomposer internally
export TARGET_DIR="${TEST_TMP_DIR}/libs"
