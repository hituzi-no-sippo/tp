#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-12-23T15:15:10+0900
# @(#) Copyright (C) 2023 hituzi no sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

origin_HEAD_SHA="$(git ls-remote origin HEAD | cut --fields=1)"
HEAD_SHA="$(git rev-parse HEAD)"
revision_range=$(
  [ "$origin_HEAD_SHA" = "$HEAD_SHA" ] &&
    echo 'HEAD' ||
    echo "$origin_HEAD_SHA..$HEAD_SHA"
)

git log --pretty=format:'%B' "$revision_range"
