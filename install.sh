#!/usr/bin/env bash

# Based on install script for YouCompleteMe

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

checker=$SCRIPT_DIR/syntax_checkers/xmltvfixup/xmltvfixuplint

if [[ ! -f "$checker" ]]; then
  echo "Checker $checker doesn't exist; have you moved it?"
  exit 1
fi

ln -sf $checker ~/bin/xmltvfixuplint >/dev/null 2>&1
