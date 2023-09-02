#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-08-31T19:24:10+09:00
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

main() {
  # shellcheck source=SCRIPTDIR/../utils.sh
  # References
  # - https://www.shellcheck.net/wiki/SC1091
  # - https://github.com/koalaman/shellcheck/wiki/directive#source
  . "$(dirname "$0")/../utils.sh"

  non_binary_files=$(exclude_binary_file "$@")

  if [ $? -eq 2 ]; then
    exit 2
  fi

  # Don't use shellharden to this script.
  # shellharden will change script process.
  # This is because shellharden will quote list with double quotation.
  #
  # Code after run `shellharden --replace`
  # for path in "$non_binary_files"; do
  for path in $non_binary_files; do
    if ! is_script_with_shebang "$path" || is_executable_file "$path"; then
      continue
    fi

    non_executable_scripts_with_shebang="$non_executable_scripts_with_shebang $path"
  done

  if [ "$non_executable_scripts_with_shebang" = '' ]; then
    exit 0
  fi

  echo "$non_executable_scripts_with_shebang" | cut --character 2-

  exit 1
}

main "$@"
