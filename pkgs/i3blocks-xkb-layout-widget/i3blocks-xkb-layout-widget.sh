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

cat <(xkb-switch) <(xkb-switch -W) | xkb_layout |
	xargs -I % echo "<span foreground=\"#$bg\"><span background=\"#$bg\" color=\"#$fg\">%</span></span>"
