#!/bin/env sh
# Turn my second monitor off and on to trigger Gnome repositioning all windows.
# Workaround for a Gnome Wayland bug where windows are stuck being maximized
# while actually only take up part of the screen after the screen wakes up from sleep.
gnome-randr --output DP-1 --off && gnome-randr --output DP-1 --auto
