#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-12T09:49:01+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

MAX_LIMIT_BYTE_IEC='500K'

convert_number_from_IEC() {
  numfmt --from=iec --to=none "$1"
}

read_file_size_byte() {
  stat --format='%s' "$@"
}

is_file_size_over_limit() {
  size_byte=$(read_file_size_byte "$1")

  if [ $? -eq 1 ]; then
    exit 1
  fi

  if [ "$size_byte" -le "$2" ]; then
    return 0
  fi

  printf 'Path: %s: Byte Size (IEC): %s\n' \
    "$path" \
    "$(numfmt --from=none --to=iec "$size_byte")"

  return 1
}

contains_file_over_limit_size() {
  limit_byte="$1"
  shift

  contains_over_size=0

  for path in "$@"; do
    if ! [ -f "$path" ]; then
      echo "$path: No such file"

      exit 2
    fi

    if ! is_file_size_over_limit "$path" "$limit_byte"; then
      contains_over_size=1
    fi
  done

  return "$contains_over_size"
}

main() {
  max_limit_byte=$(convert_number_from_IEC "$MAX_LIMIT_BYTE_IEC")

  if contains_file_over_limit_size "$max_limit_byte" "$@"; then
    exit 0
  fi

  echo 'Some files are oversized.'
  echo "Max limit byte (IEC): $MAX_LIMIT_BYTE_IEC."

  exit 1
}

main "$@"
