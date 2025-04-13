#!/usr/bin/env bash

set -euo pipefail

cache_directory="${ROFI_COMMANDER_CONFIG_DIRECTORY:-"${HOME}/.cache/rofi-commander"}"
ref_config_file="${ROFI_COMMANDER_REF_CONFIG_FILE:-"${cache_directory}/ref"}"
exec_command="${ROFI_COMMANDER_EXEC_COMMAND:-"exec"}"
clipboard_copy_command="${ROFI_COMMANDER_CLIPBOARD_COPY_COMMAND:-"xclip -r -selection c"}"
ref_data_file="${ROFI_COMMANDER_REF_DATA_FILE:-"$HOME/github.com/fantasygiveup/restricted/ref.gpg"}"

ref() {
	mkdir -p "$cache_directory"

	local data=$(
		gpg -d "$1" 2>/dev/null |
			awk 'NF > 0 {$NF = gensub(/./, "*", "g", $NF); print NR, $0}' |
			rofi -dmenu |
			awk '{print $1, $(NF-1)}'
	)

	awk '{print $2}' <<<"$data" >"$ref_config_file"

	# Save last column to clipboard.
	local line=$(awk '{print $1}' <<<"$data")
	gpg -d "$1" 2>/dev/null |
		awk -v line="$line" 'NR==line {print $NF}' |
		eval "$clipboard_copy_command"
}

ref_data() {
	local data="$(cat "$ref_config_file")"
	notify-send -a 'Ref Data: Clipboard' "$data"
	eval "$clipboard_copy_command" <<<"$data"
}

case "$1" in
commands)
	rofi -modi drun,run -show drun
	;;
cliphist)
	cliphist list | rofi -dmenu | cliphist decode 2>/dev/null |
		eval "$clipboard_copy_command"
	;;
ref)
	ref "${ref_data_file}"
	;;
ref-data)
	ref_data
	;;
esac
