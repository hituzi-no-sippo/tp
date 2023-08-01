#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-02T16:57:13+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

exclude_binary_file() {
  if [ "$#" -lt 1 ]; then
    {
      echo 'Requires one or more arguments.'
      echo 'Usage:'
      echo "- sh $0 ./README.md"
      echo "- sh $0 ./README.md ./fzf"
    } >&2

    exit 2
  fi

  grep \
    --binary-files=without-match \
    --files-with-matches \
    --max-count=1 \
    '' \
    "$@"
}
