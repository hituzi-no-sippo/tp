#!/usr/bin/env bash
#
# @(#) v0.1.0 2023-11-11T08:22:07+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

printf '%s' "$@" |
  tr '_-' ' '
