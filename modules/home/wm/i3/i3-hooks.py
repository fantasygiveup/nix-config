#!/usr/bin/env python3
from i3ipc import Connection, Event
import subprocess

i3 = Connection()


def on_window_focus(i3, event):
    focused_window = event.container
    focused_workspace = i3.get_tree().find_focused().workspace()

    if len(focused_workspace.leaves()) > 1:
        i3.command("gaps top current set 0")
    else:
        i3.command("gaps top current set 2")


def on_workspace_init(self, event):
    if event.current:
        if event.current.num != 1:
            i3.command("bar mode dock")


def on_workspace_focus(self, event):
    if event.current:
        i3.command("rename workspace \"{}\" to \"{}:{}\"".format(
            event.current.name, event.current.num, "●"))
        i3.command("rename workspace \"{}\" to \"{}:{}\"".format(
            event.old.name, event.old.num, ""))


i3.on(Event.WINDOW_FOCUS, on_window_focus)
i3.on(Event.WORKSPACE_FOCUS, on_workspace_focus)
i3.main()
