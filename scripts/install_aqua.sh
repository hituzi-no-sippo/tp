#!/usr/bin/env bash
# MIT License
#
# Copyright (c) 2021 aquaproj
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# https://raw.githubusercontent.com/aquaproj/aquaproj.github.io/1e215ad705b68afdf4911cd1c5e8b64698a943b7/LICENSE

# Does not insert a blank line between `aqua-installer |` and `bash -s`.
# This is to enable automatic update for the version of aqua with Renovate.
# References
# - https://aquaproj.github.io/docs/products/aqua-installer/#shell-script
# - https://aquaproj.github.io/docs/products/aqua-renovate-config#installer-script-preset
# - https://github.com/aquaproj/aqua-renovate-config/blob/eea13b7fe6f85887cc02044ecc0cabffe8a59dd0/installer-script.json#L13-L24
#   v1.10.0 Commit on 2023-09-26
#
curl \
  --location \
  --silent \
  --fail \
  --show-error \
  https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.1.2/aqua-installer | bash -s -- -v v2.13.0
