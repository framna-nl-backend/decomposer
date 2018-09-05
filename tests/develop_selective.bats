load helpers

@test "develop selective: no decomposer.json" {
  run_decomposer develop lib1
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: No decomposer.json found." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}
