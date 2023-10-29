#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-11-08T15:13:25+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

main() {
  # References
  # - https://www.shellcheck.net/wiki/SC1091
  # - https://github.com/koalaman/shellcheck/wiki/directive#source
  # shellcheck source=SCRIPTDIR/../utils.sh
  . "$(git rev-parse --show-toplevel)/.lefthook/asciidoc/utils.sh"

  convert_asciidoc_to_html \
    --failure-level=WARNING \
    "$@"
  lint_result="$?"

  remove_html_converted_from_asciidoc "$@"

  return "$lint_result"
}

main "$@"
