#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-05T19:57:33+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

main() {
  # References
  # - https://www.shellcheck.net/wiki/SC1091
  # - https://github.com/koalaman/shellcheck/wiki/directive#source
  # shellcheck source=SCRIPTDIR/../../scripts/asciidoc.sh
  . "$(git rev-parse --show-toplevel)/.lefthook/scripts/asciidoc.sh"

  convert_asciidoc_to_html "$@"
  lint_result="$?"

  remove_html_converted_from_asciidoctor "$@"

  return "$lint_result"
}

main "$@"
