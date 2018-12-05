complete -W “home data images baw” decomposer

_decomposer()
{
    local curr_arg;
  	curr_arg=${COMP_WORDS[COMP_CWORD]}
  	COMPREPLY=( $(compgen -W 'install develop help' -- $curr_arg ) );
} &&
complete -F _decomposer decomposer