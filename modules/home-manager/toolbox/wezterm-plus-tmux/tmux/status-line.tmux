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

rarrow=$(tmux_get '@tmux_status_line_right_arrow_icon' '')
larrow=$(tmux_get '@tmux_status_line_left_arrow_icon' '')
sep=" "

TC='#eff1f5'

G0=$(tmux_get @tmux_status_line_g0 "#4c4f69")
G1=$(tmux_get @tmux_status_line_g1 "#cccccc")
G2=$(tmux_get @tmux_status_line_g2 "#9f6414")
G3=$(tmux_get @tmux_status_line_g2 "#f0d2a7")

tmux_set status-right-bg "$G0"
tmux_set status-right-length 150

RS="$RS#[fg=$TC,bg=$TC]$sep#[fg=$G1,bg=$TC]$larrow#[fg=$G0,bg=$G1] #(date '+%H:%M %a %d %b')#[fg=$G1,bg=$TC]$rarrow"
RS="$RS#[fg=$TC,bg=$TC]$sep#[fg=$G1,bg=$TC]$larrow#[fg=$G0,bg=$G1]󰍢 #(dunstctl-count-history)#[fg=$G1,bg=$TC]$rarrow"
RS="$RS#[fg=$TC,bg=$TC]$sep#[fg=$G3,bg=$TC]$larrow#[fg=$G2,bg=$G3]#S#[fg=$G3,bg=$TC]$rarrow"

tmux_set status-right "$RS"
