#!/bin/bash

gnome-terminal -- bash -c "make run-dev"
i3-msg -q split v
gnome-terminal -- bash -c "make test-watch"
i3-msg -q split v
gnome-terminal -- bash -c "make build-watch"
i3-msg -q focus up
i3-msg -q focus up
i3-msg -q resize shrink height 200
i3-msg -q focus left
i3-msg -q resize grow width 300
vim .
