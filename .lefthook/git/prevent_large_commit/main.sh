#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-09-01T19:48:25+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

MAX_CHANGE_COUNT=250
INSERT_CHANGE_INDEX=5
DELETE_CHANGE_INDXE=7

read_diff_stat_in_satged() {
  stat_flag=$("$1" && echo "shortstat" || echo "stat")
  shift

  git diff --cached "--$stat_flag" "$@"
}

sum_changed() {
  change_stat=$(read_diff_stat_in_satged true "$@")
  insert_count=$(
    echo "$change_stat" | cut --delimiter=' ' --fields="$INSERT_CHANGE_INDEX"
  )
  delete_count=$(
    echo "$change_stat" | cut --delimiter=' ' --fields="$DELETE_CHANGE_INDXE"
  )

  echo $((insert_count + delete_count))
}

main() {
  change_count=$(sum_changed "$@")

  if [ "$change_count" -le "$MAX_CHANGE_COUNT" ]; then
    exit 0
  fi

  echo 'Please reduce the number of changed lines.'
  echo 'It exceeds the maximum number of changed lines.'
  echo "Changed Lines: $change_count."
  echo "Max Changed Lines: $MAX_CHANGE_COUNT."
  echo 'Details'
  read_diff_stat_in_satged false "$@"

  exit 1
}

main "$@"
