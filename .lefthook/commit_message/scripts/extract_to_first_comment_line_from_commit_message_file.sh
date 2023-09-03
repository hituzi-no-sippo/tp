#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-09-22T05:17:44+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

if [ "$#" -ne 1 ]; then
  {
    echo 'Requires one argument.'
    echo 'Usage:'
    echo "- extract_commit_msg 'msg # comment'"
  } >&2

  exit 2
fi

if ! [ -r "$1" ]; then
  printf "Can't read %s\n" "$1" >&2

  exit 2
fi

line_number_of_first_comment=$(
  grep --line-number --max-count=1 '^#' "$1" |
    cut --delimiter=':' --fields=1
)
if [ "$line_number_of_first_comment" = '' ]; then
  cat "$1"
else
  head --lines=$((line_number_of_first_comment - 1)) "$1"
fi
