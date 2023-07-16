#!/usr/bin/env bash
#
# @(#) v0.2.0 2023-07-13T06:55:34+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

err() {
  printf '[%s]: %s\n' "$(date +'%Y-%m-%dT%H:%M:%S%z')" "$*" >&2
}

info() {
  printf "\n%s\n" "${*}"
}

install_tools_with_version_manager() {
  info 'Will install tools with aqua.'

  if ! aqua install --only-link; then
    err 'Failed tool install with aqua'

    return 1
  fi

  info 'Successful lazy Install. Download a tool when that is executed.'
}
setup_git_hook() {
  info "Setup Git Hooks"

  if ! lefthook install --aggressive; then
    err 'Failed git hook setup'

    return 1
  fi
}

main () {
  info 'Setup Start'

  install_tools_with_version_manager
  setup_git_hook

  info 'Setup End'
}

main
