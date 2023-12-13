#!/usr/bin/env bash
#
# @(#) v0.1.0 2023-12-20T13:21:11+09:00
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

declare -r COMMAND_TO_CONVERT_ASCIIDOC_TO_HTML='convert-asciidoc-to-html-with-css'

watch_docs_with_lefthook() {
  # Reasons for not running watchexec in Lefthook.
  # - You cannot stop a watchexec process
  # - You cannot see a result of Lefthook
  # A Lefthook configuration when test running watchexec in Lefthook
  # ```YAML
  # live-preview-docs:
  #   parallel: true
  #   commands:
  #     devserver:
  #       run: devserver
  #     watch-asciidoc:
  #       run: |
  #         watchexec --exts adoc \
  #           -- \
  #           lefthook run convert-asciidoc-to-html
  # ```
  # watchexec options
  # - `watch`
  #    watchexec --help
  #    > Watch a specific file or directory
  # - `exts`
  #    watchexec --help
  #    > Filename extensions to filter to
  #    If you do not give the option,
  #    watchexec passes a modified directory to a command as well.
  # - `poll=1s`
  #    Polls file system changes at 1 second intervals.
  # - `on-busy-update=none`
  #    watchexec --help
  #    > Ignores events while the command is running
  #    > and may be useful to avoid spurious changes made by that command,
  # - `emit-events-to=stdin`
  #    Outputs a modified file path to STDIN.
  # - `postpone`
  #    watchexec --help
  #    > Wait until first change before running command
  # Environment variables for Lefthook
  # - LEFTHOOK_EXCLUDE
  #   Skips commands in Lefthook.
  #   - always-update-modify-time
  #     Lefthook keeps on running all the time,
  #     if Lefthook does not exclude commands
  #     with `always-update-modify-time` tag.
  #     Because commands with `always-update-modify-time` tag
  #     changes a modified time of a file,
  #     watchexec detects a changed metadata (modified time)
  #     and run Lefthook again.
  #   References
  #   - https://github.com/evilmartians/lefthook/blob/9b072e6622857ceb8d40a173ba39ae97afb35957/docs/usage.md#lefthook_exclude
  #     v1.5.5 Commit on 2023-12-01
  watchexec \
    --watch README.adoc \
    --watch docs \
    --exts adoc \
    --poll=1s \
    --on-busy-update=do-nothing \
    --emit-events-to=stdin \
    --postpone \
    --env LEFTHOOK_EXCLUDE="always-update-modify-time,$2" \
    -- \
    "lefthook run $1"
}
watch_asciidoc() {
  watch_docs_with_lefthook \
    "$COMMAND_TO_CONVERT_ASCIIDOC_TO_HTML"
}
watch_docs() {
  # - `$(cut --delimiter=":" --fields=2)`
  #   Do not expand here.
  #   Because lefthook cannot read a modified file path from watchexec,
  #   if expand `$(cut ...)` here.
  #   shellcheck disable=SC2016
  # - `lint-asciidoc`
  #   By passing this argument,
  #   Lefthook does not run `lint-asciidoc` command.
  #   The reason why lefthook does not run `lint-asciidoc` command is
  #   to remove HTML converted from AsciiDoc.
  # - `{staged_files}` in Lefthook configuration
  #   `{staged_files}` becomes a value of `files` option
  watch_docs_with_lefthook \
    'pre-commit --files=$(cut --delimiter=":" --fields=2)' \
    'lint-asciidoc'
}
run_watchers() {
  watch_asciidoc &
  watch_docs
}

main() {
  # Skips outputs of Lefthook.
  # References
  # - https://github.com/evilmartians/lefthook/blob/9b072e6622857ceb8d40a173ba39ae97afb35957/docs/configuration.md#skip_output
  # - https://github.com/evilmartians/lefthook/blob/9b072e6622857ceb8d40a173ba39ae97afb35957/docs/usage.md#lefthook_quiet
  # v1.5.5 Commit on 2023-12-01
  #
  # Does not set `execution`
  # because you want to display AsciiDoc warnings
  # and Vale results (warnings / suggestions)
  # Examples of AsciiDoc warning
  # - asciidoctor: WARNING: foo.adoc: line 1: section title out of sequence: expected level 1, got level 2
  # - asciidoctor: WARNING: skipping reference to missing attribute: bar
  # Example of Vale result (warning / suggestion)
  # foobar.adoc
  # 1:1  suggestion ...
  # 2:1  warning    ...
  declare -x -r LEFTHOOK_QUIET='meta,skips,empty_summary,success'

  if lefthook run "$COMMAND_TO_CONVERT_ASCIIDOC_TO_HTML"; then
    run_watchers

    lefthook run remove-html-converted-from-asciidoc
  fi
}

main
