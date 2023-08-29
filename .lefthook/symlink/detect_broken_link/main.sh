#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-29T18:26:03+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

is_non_existing_path() {
  # `is_non_existing_path` function is called
  # from `select_symlink_with_target_by_callback` function.
  # shellcheck disable=SC2317
  test ! -e "$1"
}
main() {
  # shellcheck source=SCRIPTDIR/../utils.sh
  # References
  # - https://www.shellcheck.net/wiki/SC1091
  # - https://github.com/koalaman/shellcheck/wiki/directive#source
  . "$(dirname "$0")/../utils.sh"

  broken_links=$(
    # Use "$*",
    # Because treats all the arguments as a single space-separated string.
    # Don't use "$@".
    select_symlink_with_target_by_callback "$*" is_non_existing_path
  )

  if [ "$broken_links" = '' ]; then
    exit 0
  fi

  echo "$broken_links"

  exit 1
}

main "$@"
