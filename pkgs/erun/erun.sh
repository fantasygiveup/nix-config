#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
COMMAND="$1"

elixir "$SCRIPT_DIR"/../opt/erun/scripts/"$COMMAND".exs "$@"
