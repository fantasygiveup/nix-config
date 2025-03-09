#!/usr/bin/env bash

set -euo pipefail

font_size="${BEMENU_COMMANDER_FONT_SIZE:-"14"}"
font="${BEMENU_COMMANDER_FONT:-"JetBrainsMono Nerd Font Mono Bold ${font_size}"}"
color_bg="${BEMENU_COMMANDER_COLOR_BG:-"#000000"}"
color_text="${BEMENU_COMMANDER_COLOR_FG:-"#cdd6f4"}"
color_match="${BEMENU_COMMANDER_COLOR_TEXT:-"#f38ba8"}"
color_prompt="${BEMENU_COMMANDER_COLOR_TEXT:-"#addba9"}"
config_directory="${BEMENU_COMMANDER_CONFIG_DIRECTORY:-"${HOME}/.config/bemenu-commander"}"
ref_config_file="${BEMENU_COMMANDER_REF_CONFIG_FILE:-"${config_directory}/ref"}"
line_height="${BEMENU_COMMANDER_LINE_HEIGHT:-"32"}"
exec_command="${BEMENU_COMMANDER_EXEC_COMMAND:-"exec"}"
clipboard_paste_command="${BEMENU_COMMANDER_CLIPBOARD_PASTE_COMMAND:-"xclip -r -selection c"}"
ref_data_file="${BEMENU_COMMANDER_REF_DATA_FILE:-"$HOME/github.com/fantasygiveup/restricted/ref.gpg"}"

read -r -a bemenu_color_opts <<<"--tb=${color_bg} \
    --fb=${color_bg} --cb=${color_bg} \
    --nb=${color_bg} --hb=${color_bg} \
    --fbb=${color_bg} --sb=${color_bg} \
    --ab=${color_bg} --scb=${color_bg} \
    --tf=${color_prompt} --af=${color_text} \
    --ff=${color_text} \
    --nf=${color_text} \
    --hf=${color_match}"

ref() {
	mkdir -p "$config_directory"

	local data=$(
		gpg -d "$1" 2>/dev/null |
			awk 'NF > 0 {$NF = gensub(/./, "*", "g", $NF); print NR, $0}' |
			bemenu -i "${bemenu_color_opts[@]}" --fn "${font}" -p "ref" -H "${line_height}" -n -l 999 |
			awk '{print $1, $(NF-1)}'
	)

	awk '{print $2}' <<<"$data" >"$ref_config_file"

	# Save last column to clipboard.
	local line=$(awk '{print $1}' <<<"$data")
	gpg -d "$1" 2>/dev/null |
		awk -v line="$line" 'NR==line {print $NF}' |
		eval "$clipboard_paste_command"
}

ref_data() {
	local data="$(cat "$ref_config_file")"
	notify-send -a 'Ref Data: Clipboard' "$data"
	eval "$clipboard_paste_command" <<<"$data"
}

case "$1" in
commands)
	bemenu-run -i "${bemenu_color_opts[@]}" --fn "${font}" \
		-p "run" -H 40 -n >/dev/null 2>&1 |
		eval "$exec_command"
	;;
cliphist)
	cliphist list |
		bemenu -i "${bemenu_color_opts[@]}" --fn "${font}" -p "cliphist" -H "${line_height}" -n -l 999 |
		cliphist decode 2>/dev/null |
		eval "$clipboard_paste_command"
	;;
ref)
	ref "${ref_data_file}"
	;;
ref-data)
	ref_data
	;;
esac
