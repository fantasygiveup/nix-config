#!/usr/bin/env bash

# Source: https://github.com/vivien/i3blocks-contrib/tree/master/i3-focusedwindow

while :; do
	ID=$(xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}')
	if [[ $1 ]]; then
		TITLE=$(xprop -id $ID -len $1 | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
		echo "$TITLE"
	else
		TITLE=$(xprop -id $ID | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
		echo "$TITLE"
	fi

	sleep 1
done
