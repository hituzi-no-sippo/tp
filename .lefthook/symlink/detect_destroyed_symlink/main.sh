#!/usr/bin/env sh
#
# @(#) v0.1.0 <ISO8601_DATATIME_EXTENDED_FORMAT>
# @(#) Copyright (C) <YEAR> hituzi-no-sippo
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

if [ "$#" -lt 1 ]; then
  {
    echo 'Requires one or more arguments.'
    echo 'Usage:'
    echo "- sh $0 ./symlink ./README_link"
    echo "- sh $0 ./symlink"
  } >&2

  exit 1
fi

SYMLINK_FILE_MODE='120000'
NON_SYMLINK_FILE_MODE='000000'
FILE_MODE_HEAD_INDEX=4
FILE_MODE_INDEX_INDEX=5
HASH_HEAD_INDEX=7
HASH_INDEX_INDEX=8
PATH_INDEX=9

extract_field_from_git_status_format_v2() {
  echo "$1" | cut --delimiter=' ' --fields="$2"
}

is_typechange_from_symlink() {
  file_mode_HEAD=$(
    extract_field_from_git_status_format_v2 "$1" "$FILE_MODE_HEAD_INDEX"
  )
  file_mode_index=$(
    extract_field_from_git_status_format_v2 "$1" "$FILE_MODE_INDEX_INDEX"
  )

  test "$file_mode_HEAD" = "$SYMLINK_FILE_MODE" -a \
    "$file_mode_index" != "$SYMLINK_FILE_MODE" -a \
    "$file_mode_index" != "$NON_SYMLINK_FILE_MODE"
}

calc_object_size() {
  git cat-file -s "$1"
}

read_content_with_hash() {
  git cat-file -p "$1"
}

is_same_content_by_hash() {
  test "$(read_content_with_hash "$1")" = "$(read_content_with_hash "$2")"
}

is_destroyed_symlink() {
  if ! is_typechange_from_symlink "$1"; then
    return 1
  fi

  hash_HEAD=$(extract_field_from_git_status_format_v2 "$1" "$HASH_HEAD_INDEX")
  hash_index=$(extract_field_from_git_status_format_v2 "$1" "$HASH_INDEX_INDEX")

  if [ "$hash_HEAD" = "$hash_index" ]; then
    return 0
  fi

  size_HEAD=$(calc_object_size "$hash_HEAD")
  size_index=$(calc_object_size "$hash_index")

  if [ "$size_index" -gt $((size_HEAD + 2)) ]; then
    return 1
  fi

  is_same_content_by_hash "$hash_HEAD" "$hash_index"
}

select_destroyed_symlink() {
  paths=''

  while read -r line; do
    if ! is_destroyed_symlink "$line"; then
      continue
    fi

    path=$(extract_field_from_git_status_format_v2 "$line" "$PATH_INDEX")

    paths="$paths $path"
  done <<LINES
$(git status --porcelain=v2 -- "$@")
LINES
  # Don't use shellharden to this script.
  # shellharden will change script process.
  # This is because shellharden will quote variables and command substitution
  # with double quotation even in here document.
  #
  # Code after run `shellharden --replace`
  #  done <<LINES
  #"$(git status --porcelain=v2 -- "$@")"
  #LINES

  echo "$paths" | cut --character 2-
}

main() {
  links=$(select_destroyed_symlink "$@")

  if [ "$links" = '' ]; then
    exit 0
  fi

  echo "$links"

  exit 1
}

main "$@"
