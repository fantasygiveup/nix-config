#!/usr/bin/env bash

# Print keyboard layout with emoji country flag

set -euo pipefail

bg="$1"
fg="$2"

xkb_layout() {
	while read -r line; do
		case "$line" in
		us) echo "🇺🇸 us" ;;
		ua) echo "🇺🇦 ua" ;;
		pl) echo "🇵🇱 pl" ;;
		*) echo "locale not found" ;;
		esac
	done
}

if [ -n "${BLOCK_BUTTON-}" ]; then
	xkb-switch -n
fi

code="$(xkb-switch)"
xkb_layout <<<"$(echo "$code")" | xargs -I % echo "<span foreground=\"#$bg\"><span background=\"#$bg\" color=\"#$fg\">%</span></span>"
