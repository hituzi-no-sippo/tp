#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-05T19:57:33+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

insert_final_newline() {
  echo "$@" |
    # Enclose expression (`$a\`) in double quotation marks
    # because it violates the shell check SC2016.
    # References
    # - https://www.shellcheck.net/wiki/SC2016
    xargs sed --in-place --expression="\$a\\"
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

  insert_final_newline "$files"
}

main "$@"
