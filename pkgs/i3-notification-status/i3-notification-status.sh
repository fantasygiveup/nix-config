#!/usr/bin/env bash

set -euo pipefail

rarrow=""
larrow=""

# Match tmux 'status-line'
mode="$1"
shift

tmux_pattern="#[fg=%s,bg=%s]$larrow#[fg=%s,bg=%s] 💬 #[fg=%s,bg=%s]$rarrow"

tmux_widget() {
	urgent="$(i3-msg -t get_tree | jq '.. | select(.urgent? == true) | {id: .window, name: .name, class: .window_properties.class}')"
	notifications_count="$(dunstctl count history)"

	if [[ -n "$urgent" ]]; then
		printf "$tmux_pattern" "$2" "$1" "$3" "$2" "$2" "$1"
	elif [[ "$notifications_count" -gt 0 ]]; then
		printf "$tmux_pattern" "$4" "$1" "$5" "$4" "$4" "$1"
	else
		printf "$tmux_pattern" "$6" "$1" "$7" "$6" "$6" "$1"
	fi
}

i3blocks_pattern="<span foreground=\"%s\">$larrow<span background=\"%s\" color=\"%s\"> 💬 </span>$rarrow</span>\n"

i3blocks_widget() {
	urgent="$(i3-msg -t get_tree | jq '.. | select(.urgent? == true) | {id: .window, name: .name, class: .window_properties.class}')"
	notifications_count="$(dunstctl count history)"

	if [[ -n "$urgent" ]]; then
		printf "$i3blocks_pattern" "$1" "$1" "$2"

		# Switch to the latest urgent window..
		if [ -n "${BLOCK_BUTTON-}" ]; then
			setsid i3-msg '[urgent=latest] focus' &>/dev/null || true &
		fi
	elif [[ "$notifications_count" -gt 0 ]]; then
		printf "$i3blocks_pattern" "$3" "$3" "$4"

		# Show notification list on any mouth event.
		if [ -n "${BLOCK_BUTTON-}" ]; then
			setsid rofi-commander notifications-history &>/dev/null &
		fi
	else
		printf "$i3blocks_pattern" "$5" "$5" "$6"
	fi
}

case "$mode" in
tmux) tmux_widget $@ ;;
i3blocks) i3blocks_widget $@ ;;
*) echo "no target is provided" >&2 ;;
esac
