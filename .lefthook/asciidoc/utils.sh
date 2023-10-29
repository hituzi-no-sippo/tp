#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-11-08T15:07:30+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

convert_asciidoc_to_html() {
  if [ "$#" -lt 1 ]; then
    {
      printf 'Requires one or more arguments.\n'
      printf 'Usage:\n'
      printf -- '- convert_asciidoc_to_html ./README.adoc\n'
      printf -- '- convert_asciidoc_to_html ./README.adoc ./docs\n'
    } >&2

    return 2
  fi

  # Does not use `--out-file=''`.
  # You does not know which file is causing the error.
  # - `embedded`
  #   Prevent contain CSS to HTML
  #   https://docs.asciidoctor.org/asciidoc/latest/attributes/document-attributes-ref/#intrinsic-attributes
  # - `failure-level=WARNING`
  #   Non-zero exit code if exists warning.
  #   https://docs.asciidoctor.org/asciidoc/latest/attributes/unresolved-references/#forcing-failure
  # - `attribute attribute-missing=warn@`
  #   Attribute missing is treated as warning.
  #   https://docs.asciidoctor.org/asciidoc/latest/attributes/unresolved-references/#missing
  bundle exec \
    asciidoctor \
    --embedded \
    --failure-level=WARNING \
    --attribute attribute-missing=warn@ \
    --verbose \
    "$@"
}

remove_html_converted_from_asciidoctor() {
  if [ "$#" -lt 1 ]; then
    {
      printf 'Requires one or more arguments.\n'
      printf 'Usage:\n'
      printf -- '- remove_html_converted_from_asciidoctor ./README.adoc\n'
      printf -- '- remove_html_converted_from_asciidoctor ./README.adoc ./USAGE.adoc\n'
    } >&2

    return 2
  fi

  echo "$@" |
    sed --expression='s/\.adoc/.html/g' |
    xargs rm --force
}
