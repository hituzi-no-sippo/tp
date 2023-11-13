#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-11-11T08:44:09+0900
# @(#) Copyright (C) 2023 hituzi no sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

err() {
  printf '[%s]: %s\n' "$(date +'%Y-%m-%dT%H:%M:%S%z')" "$*" >&2
}

request_hash_for_last_push_or_remote_HEAD() {
  last_push="$(git rev-parse @\{push\})"

  if [ "$last_push" != '' ]; then
    printf '%s' "$last_push"

    return 0
  fi

  request_hash_for_remote_HEAD "$1"
}
request_hash_for_remote_HEAD() {
  git ls-remote "$1" HEAD | cut --fields=1
}
# Run Command
# `git log --pretty=format:'%B' <REVISION_RANGE>`
# `<REVISION_RANGE>` is `<@{push}|REMOTE_HEAD_BRANCH}>..HEAD`
extract_commit_message_from_HEAD_to_last_push_or_remote_HEAD() {
  hash="$(request_hash_for_last_push_or_remote_HEAD "$1")"

  if [ "$hash" = '' ]; then
    err "Could not fetch the hash for '@{push}' or remote HEAD."

    return 1
  fi

  # Commit Range
  # References
  # - https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection#Commit-Ranges
  # - https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection#_double_dot
  extract_commite_message "$hash..HEAD"
}

read_hash_for_ORIG_HEAD() {
  # - ORIG_HEAD
  #   > is created by commands that move your `HEAD` in a drastic way
  #   > (`git am`, `git merge`, `git rebase`, `git reset`),
  #   > to record the position of the `HEAD` before their operation,
  #   > so that you can easily change the tip
  #   > of the branch back to the state before you ran them.
  #   https://git-scm.com/docs/gitrevisions#Documentation/gitrevisions.txt-codeORIGHEADcode
  ORIG_HEAD_path="$(git rev-parse --git-dir)/ORIG_HEAD"

  if ! [ -r "$ORIG_HEAD_path" ]; then
    err "Can't read %s\n" "$ORIG_HEAD_path"

    return 1
  fi

  cat "$ORIG_HEAD_path"
}
extract_merge_branch_from_GIT_REFLOG_ACTION() {
  # Uses `expr` because `~=` operator is not available in `test` (`[ ... ]`).
  # https://www.shellcheck.net/wiki/SC3015
  if ! expr "$GIT_REFLOG_ACTION" : '^merge' >/dev/null; then
    err "Not a merge."

    return 1
  fi

  # > `GIT_REFLOG_ACTION` lets you specify the descriptive text written
  # > to the reflog. Here’s an example:
  # https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables
  # https://thomasvilhena.com/2021/11/prevent-merge-from-specific-branch-git-hook
  # `GIT_REFLOG_ACTION` value is `merge patch-1`,
  # when run `git merge patch-1`.
  printf '%s' "$GIT_REFLOG_ACTION" |
    cut --delimiter=' ' --fields=2
}
read_revisino_range_of_merge() {
  ORIG_HEAD="$(read_hash_for_ORIG_HEAD)"

  if [ "$ORIG_HEAD" = '' ]; then
    return 1
  fi

  merge_branch="$(extract_merge_branch_from_GIT_REFLOG_ACTION)"

  if [ "$merge_branch" = '' ]; then
    return 1
  fi

  printf '%s..%s' \
    "$ORIG_HEAD" "$merge_branch"
}
extract_commite_message_of_merge() {
  revision_range="$(read_revisino_range_of_merge)"
  reads_range="$?"

  if [ "$reads_range" != '0' ]; then
    return 1
  fi

  extract_commite_message "$revision_range"
}

read_all_commite_message() {
  extract_commite_message 'HEAD'
}

extract_commite_message() {
  git log --pretty=format:'%B' "$1"
}
