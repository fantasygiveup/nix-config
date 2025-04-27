#!/usr/bin/env bash

while :; do
	current_workspace_id="$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true) | .id')"
	workspace_windows="$(i3-msg -t get_tree | jq -r ".nodes[].nodes[].nodes[] | select(.id == "$current_workspace_id")")"
	IFS=$'\n' read -rd '' -a windows <<<"$(jq -r ".nodes[].name" <<<"$workspace_windows")"
	focused_window="$(jq -r ".nodes[] | select(.focused == true)" <<<"$workspace_windows")"
	window_pos="$(jq -r '.nodes | to_entries | map(select(.value.focused == true)) | .[0].key' <<<"$workspace_windows")"
	((window_pos++))
	focused_window_title="$(jq -r '.name' <<<"$focused_window")"

	if [[ "${#windows[@]}" -lt 2 ]] || [[ "${#focused_window_title[@]}" -eq 0 ]]; then
		echo "$focused_window_title"
	else
		echo $focused_window_title": "$window_pos/${#windows[@]}
	fi

	sleep 1
done
