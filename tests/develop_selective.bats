load helpers

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: no decomposer.json" {
  run_decomposer develop lib1
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: No decomposer.json found." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}
