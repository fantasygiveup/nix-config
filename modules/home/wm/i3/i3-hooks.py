#!/usr/bin/env python3
from i3ipc import Connection, Event
import subprocess

i3 = Connection()


def on_workspace_focus(self, event):
    if event.current:
        i3.command("rename workspace \"{}\" to \"{}:{}\"".format(
            event.current.name, event.current.num, "🟠"))
        i3.command("rename workspace \"{}\" to \"{}:{}\"".format(
            event.old.name, event.old.num, "⚪"))


i3.on(Event.WORKSPACE_FOCUS, on_workspace_focus)
i3.main()
