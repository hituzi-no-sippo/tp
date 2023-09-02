#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-31T19:24:10+09:00
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

# References
# - https://www.shellcheck.net/wiki/SC1091
# - https://github.com/koalaman/shellcheck/wiki/directive#source
# shellcheck source=SCRIPTDIR/../scripts/exclude_binary_file.sh
. "$(git rev-parse --show-toplevel)/.lefthook/scripts/exclude_binary_file.sh"

PERMISSION_INDEX='4-6'

is_executable_file() {
  git ls-files --stage -- "$1" |
    cut --characters="$PERMISSION_INDEX" |
    grep --quiet '1\|3\|5\|7'
}
is_script_with_shebang() {
  head --lines=1 "$1" | grep --quiet "^#!"
}
