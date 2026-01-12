#!/bin/bash

set -e

flutter analyze --no-pub

script_dir="$(cd "$(dirname "$0")" && pwd)"
dirs=$(find "$script_dir" -mindepth 1 -maxdepth 1 -type d \
  -not -name '.*' \
  -print0 | xargs -0 -n1 basename)
printf "dir to analyze with dart_code_metrics: %s\n" $dirs

dcm analyze $dirs --fatal-style --fatal-warnings
dcm check-dependencies $dirs --ignored-packages=common_package

printf "Done!\n\n"
