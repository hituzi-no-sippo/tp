#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-07T13:41:14+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

remove_byte_order_marker() {
  echo "$@" |
    xargs sed --in-place --expression='1s/^\xEF\xBB\xBF//'
}

main() {
  # References
  # - https://www.shellcheck.net/wiki/SC1091
  # - https://github.com/koalaman/shellcheck/wiki/directive#source
  # shellcheck source=SCRIPTDIR/../../scripts/exclude_binary_file.sh
  . "$(git rev-parse --show-toplevel)/.lefthook/scripts/exclude_binary_file.sh"

  files=$(exclude_binary_file "$@")

  if [ $? -eq 2 ]; then
    exit 2
  fi

  if [ "$files" = '' ]; then
    exit 0
  fi

  remove_byte_order_marker "$files"
}

main "$@"
