#!/usr/bin/env sh
#
# @(#) v0.1.0 2023-12-30T15:34:53+0900
# @(#) Copyright (C) 2023 hituzi-no-sippo
# @(#) LICENSE: MIT-0 (https://choosealicense.com/licenses/mit-0/)

# Taplo uses cache for storing schemas.
# You can set used schema to be used in the followings ways:
# CLI options
# - `--default-schema-catalogs`
# - `--schema-catalog <SCHEMA_CATALOG>`
# - `--schema <SCHEMA>`
# Config file
# - `schema` table
#   https://taplo.tamasfe.dev/configuration/file.html#schema
# TOML file
# - `schema` directive
#   https://taplo.tamasfe.dev/configuration/directives.html
cache_dir="$(git rev-parse --show-toplevel)/.taplo_cache/"

mkdir --parents "$cache_dir"

taplo validate \
  --cache-path="$cache_dir" \
  "$@"
