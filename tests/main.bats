load helpers

@test "missing command" {
  run_decomposer
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: Missing command!" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "invalid command" {
  run_decomposer xxx
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: Invalid command!" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "display help" {
  run_decomposer help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "usage: decomposer <command> [<library>...]" ]
}
