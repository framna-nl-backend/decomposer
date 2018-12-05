complete -x -c decomposer \
	-a "install develop help" \
	-d install 'install all the libraries and generate an include file' \
	-d develop 'same as install, add an extra check to error out if include file is outdated' \
	-d help 'display a help message'