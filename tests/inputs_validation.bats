load helpers

SUITE_NAME=$( test_suite_name )

@test "${SUITE_NAME}: missing command" {
  run_decomposer
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: Missing command!" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: invalid command" {
  run_decomposer xxx
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: Invalid command!" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: install without decomposer.json" {
  run_decomposer install
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: No decomposer.json found." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "${SUITE_NAME}: develop without decomposer.json" {
  run_decomposer develop
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: No decomposer.json found." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

