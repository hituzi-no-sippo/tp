#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-09-01T14:10:11+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

select_symlink_with_target_by_callback() {
  links=''

  for path in $1; do
    if [ ! -L "$path" ]; then
      continue
    fi

    target="$(readlink "$path")"

    if ! "$2" "$target"; then
      continue
    fi

    links="$links\n$path -> $target"
  done

  echo "$links" | tail --lines=+2
}
