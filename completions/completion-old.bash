if ((BASH_VERSINFO[0] > 3))
then
  echo "Bash version too new for this decomposer completion."
  return
fi
_decomposer()
{
    local curr_arg=${COMP_WORDS[COMP_CWORD]}
    local line=${COMP_LINE}
    case $line in
      *install*)
        COMPREPLY=('')
        ;;
      *help*)
        COMPREPLY=('')
        ;;
      *-c*|*--changelog*)
        COMPREPLY=()
        ;;
      *--no-dev*)
        COMPREPLY=()
        ;;
      **)
    COMPREPLY=( $(compgen -W 'install help -c --changelog --no-dev' -- $curr_arg ) )
    ;;
    esac
} &&
complete -o default -F _decomposer decomposer
