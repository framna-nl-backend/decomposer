if ((BASH_VERSINFO[0] < 4))
then 
  echo "Bash version too old for this decomposer completion." 
  return
fi
_decomposer()
{
    local curr_arg=${COMP_WORDS[COMP_CWORD]}
    local line=${COMP_LINE}
    compopt +o default
    case $line in
      *develop*)
		COMPREPLY=()
		;;
      *install*)
		COMPREPLY=()
		;;
      *help*)
		COMPREPLY=()
		;;
      *-c*|*--changelog*)
        compopt -o default
        COMPREPLY=()
        ;;
      **)
		COMPREPLY=( $(compgen -W 'install develop help -c --changelog' -- $curr_arg ) )
		;;
  	esac
} &&
complete -F _decomposer decomposer