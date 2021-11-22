#!/bin/bash
##===----------------------------------------------------------------------===##
##
## This source file is part of the OneRoster open source project
##
## Copyright (c) 2021 the OneRoster project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
##
## SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------===##

##===----------------------------------------------------------------------===##
##
## This source file is part of the SwiftNIO open source project
##
## Copyright (c) 2017-2019 Apple Inc. and the SwiftNIO project authors
## Licensed under Apache License v2.0
##
## See LICENSE.txt for license information
## See CONTRIBUTORS.txt for the list of SwiftNIO project authors
##
## SPDX-License-Identifier: Apache-2.0
##
##===----------------------------------------------------------------------===##

set -eu
here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

command -v swiftformat >/dev/null 2>&1 || { echo >&2 "swiftformat needs to be installed but is not available in the path."; exit 1; }

function replace_acceptable_years() { sed -e 's/202[1-9]/YEARS/' ; }
function red_text() { printf '%b%s%b\n' '\033[0;31m' "$1" '\033[0m' ; }
function green_text() { printf '%b%s%b\n' '\033[0;32m' "$1" '\033[0m' ; }

printf "=> Checking format... "
FIRST_OUT="$(git status --porcelain)"
swiftformat . > /dev/null 2>&1
SECOND_OUT="$(git status --porcelain)"
if [[ "$FIRST_OUT" != "$SECOND_OUT" ]]; then
    red_text 'formatting issues!'
    git --no-pager diff
    exit 1
fi
green_text 'okay.'

printf "=> Checking for unacceptable language... "
# This greps for unacceptable terminology.
unacceptable_terms=(
    -e blacklis[t]
    -e whitelis[t]
    -e slav[e]
    -e sanit[y]
)

# We have to exclude the code of conduct as it gives examples of unacceptable language.
if git grep --color=never -i "${unacceptable_terms[@]}" -- . ":(exclude)CODE_OF_CONDUCT.md" > /dev/null; then
    red_text 'Unacceptable language found.'
    git grep -i "${unacceptable_terms[@]}" -- . ":(exclude)CODE_OF_CONDUCT.md"
    exit 1
fi
green_text 'okay.'

printf "=> Checking license headers...\n"
rules="$(sed -e '/^#/d' "${here}/spdx_header_rules.json")"
jq -r '.languages|keys[]' <<<"${rules}" | while read -r lang; do
  printf "   * checking $lang... "
  
  lang_hdr="$(jq -r "$(printf '.languages["%s"] as {marker:$m}|.header|($m+.[0]+$m,(.[1:-1][]|$m+.),$m+.[-1]+$m)' "$lang")" <<<"${rules}")"
  shebang="$(jq -r "$(printf '.languages["%s"].has_shebang' "$lang")" <<<"${rules}")"
  matchexpr="$(jq -r "$(printf '.languages["%s"].match_expression|join(" ")' "$lang")" <<<"${rules}")"
  
  hdrlines="$(wc -l <<<"${lang_hdr}")"
  hdrdigest="$(shasum -U -a 256 <<<"${lang_hdr}")"
  headlines=$([[ "${shebang}" == "true" ]] && echo $((hdrlines + 1)) || echo $hdrlines)

  find "${here}/.." \( \! -path './.build/*' -and \( ${matchexpr} \) \) | while read -r path; do
    if [[ "$(head -n "${headlines}" "${path}" | tail -n "${hdrlines}" | replace_acceptable_years | shasum -U -a 256)" != "${hdrdigest}" ]]; then
      red_text "missing or incorrect headers in file '${path}'!"
      diff -u <(head -n "${headlines}" "${path}" | tail -n "${hdrlines}" | replace_acceptable_years) <(echo "${lang_hdr}")
      exit 1
    fi
  done
  green_text 'okay.'
done
