#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-11-11T08:44:09+0900
# @(#) Copyright (C) 2023 hituzi no sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

err() {
  printf '[%s]: %s\n' "$(date +'%Y-%m-%dT%H:%M:%S%z')" "$*" >&2
}

request_hash_of_last_push_or_remote_HEAD() {
  last_push="$(git rev-parse @\{push\})"

  if [ "$last_push" != '' ]; then
    printf '%s' "$last_push"

    return 0
  fi

  request_hash_of_remote_HEAD "$1"
}
request_hash_of_remote_HEAD() {
  git ls-remote "$1" HEAD | cut --fields=1
}
# Run Command
# `git log --pretty=format:'%B' <REVISION_RANGE>`
# `<REVISION_RANGE>` is `<@{push}|REMOTE_HEAD_BRANCH}>..HEAD`
extract_commit_messages_from_HEAD_to_last_push_or_remote_HEAD() {
  hash="$(request_hash_of_last_push_or_remote_HEAD "$1")"

  if [ "$hash" = '' ]; then
    err "Could not fetch the hash for '@{push}' or remote HEAD."

    return 1
  fi

  # Commit Range
  # References
  # - https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection#Commit-Ranges
  # - https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection#_double_dot
  extract_commit_messages "$hash..HEAD"
}

extract_commit_messages() {
  git log --pretty=format:'%B' "$1"
}
