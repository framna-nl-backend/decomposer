load helpers

@test "install selective: no decomposer.json" {
  run_decomposer install lib1
  [ "${status}" -eq 1 ]
  [ "${lines[0]}" = "decomposer: No decomposer.json found." ]
  [ "${lines[1]}" = "Try 'decomposer help' for more information." ]
}
