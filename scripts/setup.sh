#!/usr/bin/env bash
#
# @(#) v0.1.0 2023-07-13T06:55:34+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

err() {
  printf '[%s]: %s\n' "$(date +'%Y-%m-%dT%H:%M:%S%z')" "$*" >&2
}

info() {
  printf "\n%s\n" "${1}"
}

install_tools_with_version_manager() {
  if ! aqua install --only-link; then
    err 'Failed Aqua install'

    return 1
  fi

  info 'Lazy Install. Download a tool when that is executed.'
}

main () {
  info 'Setup Start'

  install_tools_with_version_manager

  info 'Setup End'
}

main
