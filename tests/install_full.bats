load helpers

@test "install full: no decomposer.json" {
  run_decomposer install
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: No decomposer.json found." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}
