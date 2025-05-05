#!/usr/bin/env python3
from i3ipc import Connection, Event
import subprocess

i3 = Connection()

win_title = "wezterm"


def on_window_focus(i3, event):
    focused_window = event.container
    # window_name = focused_window.name
    # window_class = focused_window.window_class
    title = focused_window.window_title

    if title == win_title:
        i3.command("bar mode invisible")
    else:
        # If any of `win_title` is found on the current workspace, hide the dock.
        focused_workspace = i3.get_tree().find_focused().workspace()

        filter_titles = list(
            filter(lambda win: win.window_title == win_title,
                   focused_workspace.leaves()))

        maybe_title_win = len(filter_titles) > 0

        if maybe_title_win:
            i3.command("bar mode invisible")
        else:
            i3.command("bar mode dock")


def on_workspace_init(self, event):
    if event.current:
        if event.current.num != 1:
            i3.command("bar mode dock")


def on_workspace_focus(self, event):
    if event.current:
        i3.command("rename workspace \"{}\" to \"{}:{}\"".format(
            event.current.name, event.current.num, "🟠"))
        i3.command("rename workspace \"{}\" to \"{}:{}\"".format(
            event.old.name, event.old.num, "⚪"))


# i3.on(Event.WINDOW_FOCUS, on_window_focus)
# i3.on(Event.WORKSPACE_INIT, on_workspace_init)
i3.on(Event.WORKSPACE_FOCUS, on_workspace_focus)
i3.main()
