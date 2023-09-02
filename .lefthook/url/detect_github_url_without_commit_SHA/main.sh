#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-04T20:58:46+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)
#
# Copyright (c) 2014 pre-commit dev team: Anthony Sottile, Ken Struys
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# https://github.com/pre-commit/pre-commit-hooks/blob/1790c6b40aa27ce48236525540a5150493cf8fef/LICENSE

search_github_url() {
  # Examples of matching URLs
  # https://github.com/hituzi-no-sippo/template-repository/blob/main/LICENSE
  # https://github.com/hituzi-no-sippo/template-repository/blob/main/LICENSE#L1
  # https://github.com/hituzi-no-sippo/template-repository/blob/main/LICENSE#L1-10
  # https://github.com/hituzi-no-sippo/template-repository/blob/release/LICENSE
  echo "$@" |
    xargs \
      grep \
      --line-number \
      --extended-regexp \
      --regexp='https://github.com/[^/ ]+/[^/ ]+/blob/[^/. ]+/[^# ]+' |
    grep \
      --invert-match \
      --extended-regexp \
      --regexp='blob/[a-fA-F0-9]{4,64}/'
}

main() {
  # References
  # - https://www.shellcheck.net/wiki/SC1091
  # - https://github.com/koalaman/shellcheck/wiki/directive#source
  # shellcheck source=SCRIPTDIR/../../scripts/exclude_binary_file.sh
  . "$(git rev-parse --show-toplevel)/.lefthook/scripts/exclude_binary_file.sh"

  files=$(exclude_binary_file "$@")

  if [ $? -eq 2 ]; then
    exit 2
  fi

  if [ "$files" = '' ]; then
    exit 0
  fi

  search_github_url "$files"

  test $? -eq 1
}

main "$@"
