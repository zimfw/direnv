if (( ! ${+DIRENV_LOG_FORMAT} )) export DIRENV_LOG_FORMAT=$'\E[1mdirenv: %s\E[0m'
() {
  local -r target=${1}
  shift
  local -r cmd=${commands[${1}]}
  shift
  if [[ ! ( -s ${target} && ${target} -nt ${cmd} ) ]]; then
    ${cmd} "${@}" >! ${target} || return 1
    zcompile -UR ${target}
  fi
  source ${target}
} ${0:h}/direnv-hook-zsh.zsh direnv hook zsh
