#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-05T16:18:21+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

echo "$@" |
  grep \
    --word-regexp \
    --only-matching \
    --regexp='[[:graph:]]\+-[[:graph:]]\+'

test $? -eq 1
