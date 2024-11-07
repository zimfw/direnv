() {
  local -r target=${1}
  shift
  (( ${+commands[${1}]} )) || return 1
  if [[ ! ( -s ${target} && ${target} -nt ${commands[${1}]} ) ]]; then
    "${@}" >! ${target} || return 1
    zcompile -UR ${target}
  fi
  source ${target}
} ${0:h}/direnv-hook-zsh.zsh direnv hook zsh || return 1
if [[ -z ${NO_COLOR} && ${+DIRENV_LOG_FORMAT} -eq 0 ]] export DIRENV_LOG_FORMAT=$'\E[2mdirenv: %s\E[0m'
