#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-29T19:06:05+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

without_git_repository() {
  # `without_git_repository` function is called
  # from `select_symlink_with_target_by_callback` function.
  # shellcheck disable=SC2317
  path_from_git_root=$(
    realpath --relative-to="$(git rev-parse --show-toplevel)" "$1"
  )

  # shellcheck disable=SC2317
  test "$(echo "$path_from_git_root" | cut --characters=1-2)" = '..'
}
main() {
  # shellcheck source=SCRIPTDIR/../utils.sh
  # References
  # - https://www.shellcheck.net/wiki/SC1091
  # - https://github.com/koalaman/shellcheck/wiki/directive#source
  . "$(dirname "$0")/../utils.sh"

  symlinks_with_outside_target=$(
    # Use "$*",
    # Because treats all the arguments as a single space-separated string.
    # Don't use "$@".
    select_symlink_with_target_by_callback "$*" without_git_repository
  )

  if [ "$symlinks_with_outside_target" = '' ]; then
    exit 0
  fi

  echo "$symlinks_with_outside_target"

  exit 1
}

main "$@"
