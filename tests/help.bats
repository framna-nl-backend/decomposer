load helpers/variables
load helpers/hooks
load helpers/main

# This suite tests the "help" command

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: display help" {
  run_decomposer help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "usage: decomposer <command>" ]
}
