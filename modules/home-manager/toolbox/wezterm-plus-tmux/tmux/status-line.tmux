#!/usr/bin/env bash

# The idea is taken from https://github.com/wfxr/tmux-power.

tmux_get() {
	local value
	value="$(tmux show -gqv "$1")"
	[ -n "$value" ] && echo "$value" || echo "$2"
}

tmux_set() {
	tmux set-option -gq "$1" "$2"
}

# Options
rarrow=$(tmux_get '@tmux_status_line_right_arrow_icon' '')
larrow=$(tmux_get '@tmux_status_line_left_arrow_icon' '')
sep=" "

TC='#4c4f69'

G0=$(tmux_get @tmux_status_line_g0 "#eff1f5")
G1=$(tmux_get @tmux_status_line_g2 "#eff1f5")

# Right side of status bar
tmux_set status-right-bg "$G0"
tmux_set status-right-length 150

RS="#[fg=$G1]"
RS="$RS#[fg=$TC,bg=$G1]$larrow#[fg=$G1,bg=$TC] #(xkb-switch)#[fg=$TC,bg=$G1]$rarrow"
RS="$RS$sep#[fg=$TC,bg=$G1]$larrow#[fg=$G1,bg=$TC]󰍢 #(dunstctl-count-history)#[fg=$TC,bg=$G1]$rarrow"
RS="$RS$sep#[fg=$TC,bg=$G1]$larrow#[fg=$G1,bg=$TC] #(date '+%H:%M %a %d %b')#[fg=$TC,bg=$G1]$rarrow"
RS="$RS$sep#[fg=$TC,bg=$G1]$larrow#[fg=$G1,bg=$TC] #(mem-usage)#[fg=$TC,bg=$G1]$rarrow"
RS="$RS$sep#[fg=$TC,bg=$G1]$larrow#[fg=$G1,bg=$TC] #(cpu-usage)#[fg=$TC,bg=$G1]$rarrow"
RS="$RS$sep#[fg=$TC,bg=$G1]$larrow#[fg=$G1,bg=$TC] $USER@#(hostname)#[fg=$TC,bg=$G1]$rarrow"

tmux_set status-right "$RS"
