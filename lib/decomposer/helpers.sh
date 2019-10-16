# run a function over each library JSON object
map_libraries_object() {
  local file="$1"
  local function="$2"

  local libraries_names object result=0

  libraries_names=$( jq -r ".|to_entries|map(.key|tostring)|.[]" "${file}" )

  for name in ${libraries_names}; do
    object=$( jq ".\"${name}\"" "${file}" )

    if ! "${function}" "${name}" "${object}"; then
      result=1
    fi
  done

  return "${result}"
}

# run a function over each library repo path
map_libraries_repo() {
  local file="$1"
  local function="$2"

  local libraries_names object result=0

  libraries_names=$( jq -r ".|to_entries|map(.key|tostring)|.[]" "${file}" )

  for name in ${libraries_names}; do
    object=$( jq ".\"${name}\"" "${file}" )

    library_target_dir=$( jq -r '."target-dir"' <<< "${object}" )
    version=$( jq -r '.version' <<< "${object}" )

    if [ "${library_target_dir}" = "null" ]; then
      library_target_dir="${name}-${version}"
    else
      library_target_dir="${name}-${version}${library_target_dir}"
    fi

    if ! "${function}" "${name}" "${TARGET_DIR}/${library_target_dir}"; then
      result=1
    fi
  done

  return "${result}"
}
