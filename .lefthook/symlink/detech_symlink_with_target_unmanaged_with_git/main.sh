#!/usr/bin/env sh
#
# @(#) v0.1.0 <ISO8601_DATATIME_EXTENDED_FORMAT>
# @(#) Copyright (C) <YEAR> hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

is_unmanaged_file() {
  # `is_unmanaged_file` function is called
  # from `select_symlink_with_target_by_callback` function.
  # shellcheck disable=SC2317
  test "$(git ls-files -- "$1" 2>/dev/null)" = '' -a \
    "$(git check-ignore -- "$1" 2>/dev/null)" = ''
}
main() {
  # shellcheck source=SCRIPTDIR/../utils.sh
  # References
  # - https://www.shellcheck.net/wiki/SC1091
  # - https://github.com/koalaman/shellcheck/wiki/directive#source
  . "$(dirname "$0")/../utils.sh"

  symlinks_with_unmanaged_target=$(
    # Use "$*",
    # Because treats all the arguments as a single space-separated string.
    # Don't use "$@".
    select_symlink_with_target_by_callback "$*" is_unmanaged_file
  )

  if [ "$symlinks_with_unmanaged_target" = '' ]; then
    exit 0
  fi

  echo "$symlinks_with_unmanaged_target"

  exit 1
}

main "$@"
