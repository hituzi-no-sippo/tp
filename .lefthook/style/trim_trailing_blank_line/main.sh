#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-07T18:23:27+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

trim_trailing_blank_line() {
  # Change from `[[:space:]]` to `[[:blank:]\n\r]`,
  # if doesn't remove blank lines on using `[[:space:]]`.
  # References
  # - https://www.gnu.org/software/grep/manual/html_node/Character-Classes-and-Bracket-Expressions.html
  echo "$@" |
    xargs \
      sed \
      --in-place \
      --expression=':label' \
      --expression="/^[[:space:]]*$/{\$d;N;blabel}"
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

  trim_trailing_blank_line "$files"
}

main "$@"
