decomposer-generate-changelog(1)

# NAME

decomposer-generate-changelog - Generate a changelog of the main project and its libraries

# SYNOPSIS

decomposer generate-changelog [-f _file_] [-t _time_]

# DESCRIPTION

Generate a changelog of the main project and its libraries.

# OPTIONS

*-f --file* _file_
	Define the file to write the changelog to.++
Default is a _decomposer.diffnotes.md_ file in the current working directory

*-t --time* _time_
	Define the base in the local history to generate the changes against.++
Default is "5 minutes ago"

	So for example using "*-t* '1 hour ago'" would generate a file containing the
	changes from the version that was installed locally 1 hour ago
	(see *gitrevisions*(1) for allowed _time_ values. The default is to generate
	a changelog against the version from "5 minutes ago". This means that if the
	command is run just after an install command, it will report all the changes
	brought up by that last installation.

# ENVIRONMENT VARIABLES

_TARGET_DIR_
	Define the location of the installed libraries++
By default this is _/var/www/libs_
