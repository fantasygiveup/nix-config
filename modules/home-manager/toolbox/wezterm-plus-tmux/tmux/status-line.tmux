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

TC="@bg0@"

G0=$(tmux_get @tmux_status_line_g0 "@fg0@")
G1=$(tmux_get @tmux_status_line_g1 "@g1@")
G2=$(tmux_get @tmux_status_line_g2 "@g2@")
G3=$(tmux_get @tmux_status_line_g3 "@g3@")
G4=$(tmux_get @tmux_status_line_g4 "@g4@")
G5=$(tmux_get @tmux_status_line_g5 "@g5@")
G6=$(tmux_get @tmux_status_line_g6 "@g6@")
G7=$(tmux_get @tmux_status_line_g7 "@g7@")

tmux_set status-right-bg "$G0"
tmux_set status-right-length 150

RS="$RS#[fg=$TC,bg=$TC]$sep#[fg=$G1,bg=$TC]$larrow#[fg=$G0,bg=$G1] #(date '+%H:%M %a %d %b')#[fg=$G1,bg=$TC]$rarrow"
RS="$RS#[fg=$TC,bg=$TC]$sep#(i3-notification-status tmux '$TC' '$G7' '$G6' '$G5' '$G4' '$G1' '$G0')"
RS="$RS#[fg=$TC,bg=$TC]$sep#[fg=$G3,bg=$TC]$larrow#[fg=$G2,bg=$G3]#S#[fg=$G3,bg=$TC]$rarrow"

tmux_set status-right "$RS"
