() {
  builtin emulate -L zsh
  local -r target=${1}
  shift
  (( ${+commands[${1}]} )) || return 1
  local -a ztimes
  if [[ -s ${target} ]]; then
    zmodload -F zsh/stat b:zstat && zstat -A ztimes +mtime ${commands[${1}]} ${target} || return 1
    if [[ ${ztimes[1]} -le 1 ]]; then
      # Fallback to ctime when mtime is not available, as can be the case with the nix store.
      local -a zctimes
      zstat -A zctimes +ctime ${commands[${1}]} || return 1
      ztimes[1]=${zctimes[1]}
    fi
  fi
  if [[ ${ztimes[1]} -ge ${ztimes[2]} ]]; then
    "${@}" >! ${target} || return 1
    zcompile -UR ${target}
  fi
  source ${target}
} ${0:h}/direnv-hook-zsh.zsh direnv hook zsh || return 1

if [[ -z ${NO_COLOR} && ${+DIRENV_LOG_FORMAT} -eq 0 ]] export DIRENV_LOG_FORMAT=$'\E[2mdirenv: %s\E[0m'
