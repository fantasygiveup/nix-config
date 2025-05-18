#!/usr/bin/env bash

set -euo pipefail

while :; do
	current_workspace_id="$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .id')"
	workspace_windows="$(i3-msg -t get_tree | jq -r ".nodes[].nodes[].nodes[] | select(.id == "$current_workspace_id")")"
	focused_window="$(jq -r ".nodes[] | select(.focused == true)" <<<"$workspace_windows")"
	if [ -z "$focused_window" ]; then
		workspace_windows="$(i3-msg -t get_tree | jq -r ".nodes[].nodes[].nodes[] | select(.id == "$current_workspace_id") | .nodes[]")"
		focused_window="$(jq -r ".nodes[] | select(.focused == true)" <<<"$workspace_windows")"
	fi

	window_index="$(jq -r '.nodes | to_entries | map(select(.value.focused == true)) | .[0].key | select(. != null)' <<<"$workspace_windows")"
	window_pos="$((window_index + 1))"
	focused_window_title="$(jq -r '.name' <<<"$focused_window")"
	IFS=$'\n' read -rd '' -a windows <<<"$(jq -r ".nodes[].name" <<<"$workspace_windows")" || true

	if [[ "${#windows[@]}" -lt 2 ]] || [[ -z "$focused_window_title" ]]; then
		echo "$focused_window_title"
	else
		echo $focused_window_title": "$window_pos/${#windows[@]}
	fi

	sleep 1
done
