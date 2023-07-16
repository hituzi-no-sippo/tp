#!/usr/bin/env bash
#
# @(#) v0.1.0 2023-07-13T06:55:34+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

err() {
  printf '[%s]: %s\n' "$(date +'%Y-%m-%dT%H:%M:%S%z')" "$*" >&2
}

info() {
  printf "\n%s\n" "$*"
}

install_tools_with_version_manager() {
  info 'Will install tools with aqua.'

  if ! aqua install --only-link; then
    err 'Failed tool install with aqua.'

    return 1
  fi

  info 'Successful lazy install. Download a tool when that is executed.'
}

main() {
  info 'Setup Start'

  funcs=(
    'install_tools_with_version_manager'
  )

  for func in "${funcs[@]}"; do
    if ! "$func"; then
      err 'Failed setup.'

      return 1
    fi
  done

  info 'Successful setup'
}

main
