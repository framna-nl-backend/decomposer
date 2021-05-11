decomposer-lock(1)

# NAME

decomposer-lock - Lock the libraries version in the _decomposer.json_ file

# SYNOPSIS

decomposer lock [-f _file_]

# DESCRIPTION

Lock the version of all the libraries defined in the _decomposer.json_ file and
write the result to a new file.

Libraries using a branch in the "revision" field are modified to use the commit
of the tip of the branch as the new locked revision. Libraries using a tag or a
commit already are not modified.

# OPTIONS

*-f --file* _file_
	Define the file to write the new _decomposer.json_ to.++
Default is a _decomposer_new.json_ file in the current working directory

# ENVIRONMENT VARIABLES

_DECOMPOSER_TARGET_DIR_
	Define the location of the installed libraries++
By default this is _/var/www/libs_
