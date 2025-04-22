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

TC='#4c4f69'

G0=$(tmux_get @tmux_status_line_g0 "#eff1f5")
G1=$(tmux_get @tmux_status_line_g2 "#cccccc")

tmux_set status-right-bg "$G0"
tmux_set status-right-length 150

RS="$RS#[fg=$G0,bg=$G0]$sep#[fg=$G1,bg=$G0]$larrow#[fg=$TC,bg=$G1]#S#[fg=$G1,bg=$G0]$rarrow"
RS="$RS#[fg=$G0,bg=$G0]$sep#[fg=$G1,bg=$G0]$larrow#[fg=$TC,bg=$G1] #(xkb-switch)#[fg=$G1,bg=$G0]$rarrow"
RS="$RS#[fg=$G0,bg=$G0]$sep#[fg=$G1,bg=$G0]$larrow#[fg=$TC,bg=$G1]󰍢 #(dunstctl-count-history)#[fg=$G1,bg=$G0]$rarrow"
RS="$RS#[fg=$G0,bg=$G0]$sep#[fg=$G1,bg=$G0]$larrow#[fg=$TC,bg=$G1] #(date '+%H:%M %a %d %b')#[fg=$G1,bg=$G0]$rarrow"
RS="$RS#[fg=$G0,bg=$G0]$sep#[fg=$G1,bg=$G0]$larrow#[fg=$TC,bg=$G1] #(mem-usage)#[fg=$G1,bg=$G0]$rarrow"
RS="$RS#[fg=$G0,bg=$G0]$sep#[fg=$G1,bg=$G0]$larrow#[fg=$TC,bg=$G1] #(cpu-usage)#[fg=$G1,bg=$G0]$rarrow"
RS="$RS#[fg=$G0,bg=$G0]$sep#[fg=$G1,bg=$G0]$larrow#[fg=$TC,bg=$G1] $USER@#(hostname)#[fg=$G1,bg=$G0]$rarrow"

tmux_set status-right "$RS"
