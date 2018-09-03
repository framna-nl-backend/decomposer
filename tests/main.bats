@test "missing command" {
  run ./decomposer
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: Missing command!" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "invalid command" {
  run ./decomposer xxx
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: Invalid command!" ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}

@test "display help" {
  run ./decomposer help
  [ "${status}" -eq 0 ]
  [ "${lines[0]}" = "usage: decomposer <command> [<library>...]" ]
}
