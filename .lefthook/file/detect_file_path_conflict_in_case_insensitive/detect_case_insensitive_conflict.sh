#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-09T12:50:58+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

detect_case_conflict() {
  echo "$@" |
    sed "s/ /\n/g" |
    sort --ignore-case --dictionary-order |
    uniq --ignore-case --all-repeated=separate
}

main() {
  conflicting_text=$(detect_case_conflict "$@")

  if [ "$conflicting_text" = '' ]; then
    exit 0
  fi

  echo "$conflicting_text"

  exit 1
}

main "$@"
