#!/usr/bin/env bash

set -euo pipefail

rarrow=""
larrow=""

# Match tmux 'status-line'
TC='#eff1f5'
G0="#4c4f69"
G1="#cccccc"
G4="#9f6414"
G5="#f0d2a7"
G6="#bc0d33"
G7="#f8a8b9"

tmux_pattern="#[fg=%s,bg=%s]$larrow#[fg=%s,bg=%s] 󰍢 #[fg=%s,bg=%s]$rarrow"

tmux_widget() {
	urgent="$(i3-msg -t get_tree | jq '.. | select(.urgent? == true) | {id: .window, name: .name, class: .window_properties.class}')"
	notifications_count="$(dunstctl count history)"

	if [[ -n "$urgent" ]]; then
		printf "$tmux_pattern" "$G7" "$TC" "$G6" "$G7" "$G7" "$TC"
	elif [[ "$notifications_count" -gt 0 ]]; then
		printf "$tmux_pattern" "$G5" "$TC" "$G4" "$G5" "$G5" "$TC"
	else
		printf "$tmux_pattern" "$G1" "$TC" "$G0" "$G1" "$G1" "$TC"
	fi
}

i3blocks_pattern="<span foreground=\"%s\">$larrow<span background=\"%s\" color=\"%s\"> 󰍢 </span>$rarrow</span>\n"

i3blocks_widget() {
	urgent="$(i3-msg -t get_tree | jq '.. | select(.urgent? == true) | {id: .window, name: .name, class: .window_properties.class}')"
	notifications_count="$(dunstctl count history)"

	if [[ -n "$urgent" ]]; then
		printf "$i3blocks_pattern" "$G7" "$G7" "$G6"
	elif [[ "$notifications_count" -gt 0 ]]; then
		printf "$i3blocks_pattern" "$G5" "$G5" "$G4"
	else
		printf "$i3blocks_pattern" "$G1" "$G1" "$G0"
	fi
}

case "$1" in
tmux) tmux_widget ;;
i3blocks) i3blocks_widget ;;
*) echo "no target is provided" >&2 ;;
esac
