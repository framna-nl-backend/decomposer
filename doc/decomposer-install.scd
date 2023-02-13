decomposer-install(1)

# NAME

decomposer-install - Install all the libraries

# SYNOPSIS

decomposer install [--no-dev]

# DESCRIPTION

Install all the libraries defined in the _decomposer.json_ file and generates
the include file.

The include file contains a check that returns an error in case it is outdated.
This extra check is mainly useful on a development environment to get warned to
rerun _decomposer_ after the project's last pull of changes updated the
_decomposer.json_ file. It should not be necessary on a controlled production
environment. Not having it there is saving some unnecessary computing for every
process. On such a production environment, the *--no-dev* option should be then
used.

As a precaution to not wreak havoc on your development setup, _decomposer_ will
not touch libraries in _DECOMPOSER_TARGET_DIR_ that are manually installed using symbolic
links or git worktree checkouts. However, do note that in case it is a normal
git clone, _decomposer_ will reset the repo and throw away any local changes.


# OPTIONS

*--no-dev*
	Do not install development-only dependencies and also do not generate the
	outdated check in the include file

# ENVIRONMENT VARIABLES

_DECOMPOSER_TARGET_DIR_
	Define the location of the installed libraries++
By default this is _/var/www/libs_
