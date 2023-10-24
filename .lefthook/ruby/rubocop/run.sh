#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-09-09T08:55:00+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

display_usage() {
  {
    printf 'Usage:\n'
    printf -- '- sh run.sh format ./Gemfile\n'
    printf -- '- sh run.sh lint --only=Style,Layout ./Gemfile\n'
  } >&2
}

decide_filter_cops_option() {
  if [ "$1" = 'format' ]; then
    printf 'only'
  else
    return 1
  fi

  return 0
}
make_filter_cops_option() {
  filter_cops_option_name=$(decide_filter_cops_option "$1")
  last_status="$?"

  if [ "$last_status" != 0 ]; then
    printf 'Requires sub command(format, lint)\n' >&2

    display_usage

    return 2
  fi

  # It is hard to read cops as a single line (`Style,Layout,Naming...`) .
  FORMAT_COPS=$(
    tr '\n' ',' <<COPS
Style
Layout
Naming
Bundler/OrderedGems
Bundler/DuplicatedGem
Bundler/DuplicatedGroup
Bundler/GemFilename
Gemspec/OrderedDependencies
COPS
  )

  printf -- '--%s=%s' "$filter_cops_option_name" "$FORMAT_COPS"
}

main() {
  if [ "$#" -lt 2 ]; then
    printf 'Requires two or more arguments.\n' >&2

    display_usage

    return 2
  fi

  filter_cops_option=$(make_filter_cops_option "$1")
  last_status="$?"

  if [ "$last_status" != 0 ]; then
    return "$last_status"
  fi

  bundle exec rubocop \
    --color \
    --parallel \
    --cache=true \
    --force-exclusion \
    "$filter_cops_option" \
    "$@"
}

main "$@"
