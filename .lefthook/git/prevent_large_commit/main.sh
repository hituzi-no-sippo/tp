#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-09-01T19:48:25+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

INSERT_CHANGED_INDEX=5
DELETE_CHANGED_INDXE=7

read_diff_stat_in_satged() {
  stat_flag=$("$1" && echo "shortstat" || echo "stat")
  shift

  git diff --cached "--$stat_flag" "$@"
}

sum_changed_lines() {
  changed_stat=$(read_diff_stat_in_satged true "$@")
  insert_lines=$(
    echo "$changed_stat" | cut --delimiter=' ' --fields="$INSERT_CHANGED_INDEX"
  )
  delete_lines=$(
    echo "$changed_stat" | cut --delimiter=' ' --fields="$DELETE_CHANGED_INDXE"
  )

  echo $((insert_lines + delete_lines))
}

main() {
  max_changed_lines="$1"
  shift

  changed_lines=$(sum_changed_lines "$@")

  if [ "$changed_lines" -le "$max_changed_lines" ]; then
    exit 0
  fi

  echo 'Please reduce the number of changed lines.'
  echo 'It exceeds the maximum number of changed lines.'
  echo "Changed Lines: $changed_lines."
  echo "Max Changed Lines: $max_changed_lines."
  echo 'Details'
  read_diff_stat_in_satged false "$@"

  exit 1
}

main "$@"
