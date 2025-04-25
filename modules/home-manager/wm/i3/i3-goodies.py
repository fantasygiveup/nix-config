#!/usr/bin/env python3
import i3ipc
import subprocess

i3 = i3ipc.Connection()

win_title = "wezterm"


def on_window_focus(i3, event):
    focused_window = event.container
    # window_name = focused_window.name
    # window_class = focused_window.window_class
    title = focused_window.window_title

    if title == win_title:
        i3.command("bar mode hide")
    else:
        # If any of `win_title` is found on the current workspace, hide the dock.
        focused_workspace = i3.get_tree().find_focused().workspace()

        filter_titles = list(
            filter(lambda win: win.window_title == win_title,
                   focused_workspace.leaves()))

        maybe_title_win = len(filter_titles) > 0

        if maybe_title_win:
            i3.command("bar mode hide")
        else:
            i3.command("bar mode dock")


i3.on("window::focus", on_window_focus)
i3.main()
