#!/usr/bin/env bash

set -euo pipefail

case "$1" in
"-i") gnome-screenshot -i ;; # keep it's interactively as it is
"-w")
	now="$(date '+%Y-%m-%d %H-%M-%S')"
	dir="${2-"$HOME/Pictures/Screenshots"}"
	filepath="$dir/Screenshot from $now.png"

	gnome-screenshot -w -f "$filepath" &>/dev/null

	echo "$filepath"
	;;
esac
