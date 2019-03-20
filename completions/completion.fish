complete -c decomposer -e

function __decomposer_complete
	set -l args $argv
    set -l cmdline (commandline -opc) (commandline -ct)
    set -e cmdline[1]

	# If no subcommand has been given, return so this can be used as a condition.
    test -n "$cmdline[1]"
    or return
    set -l cmd $cmdline[1]
	set -e cmdline[1]

	switch "$cmd"
	case '-c' '--changelog'
		__fish_complete_path $cmdline "output file path"
	case '*'
		return
	end
end

set -l commands develop install help
complete --arguments "$commands" \
	--command decomposer \
	--no-files \
	--condition "not __fish_seen_subcommand_from $commands"

complete --arguments develop --description 'Same as install add an extra check to error out if include file is outdated' \
	--command decomposer \
	--no-files \
	--condition "not __fish_seen_subcommand_from $commands"
complete --arguments install --description 'Install all the libraries and generate an include file' \
	--command decomposer \
	--no-files \
	--condition "not __fish_seen_subcommand_from $commands"
complete --arguments help --description 'Display a help message' \
	--command decomposer \
	--no-files \
	--condition "not __fish_seen_subcommand_from $commands"

complete --command decomposer \
	--short-option c \
	--long-option changelog \
	--require-parameter \
	--description 'Generate a markdown representation of the update'

complete --command decomposer \
	--arguments '(__decomposer_complete)' \
	--no-files