if (( ! ${+DIRENV_LOG_FORMAT} )) export DIRENV_LOG_FORMAT=$'\E[1mdirenv: %s\E[0m'
() {
  local -r target=${1}
  shift
  if [[ ! ( -s ${target} && ${target} -nt ${commands[${1}]} ) ]]; then
    "${@}" >! ${target} || return 1
    zcompile -UR ${target}
  fi
  source ${target}
} ${0:h}/direnv-hook-zsh.zsh direnv hook zsh
