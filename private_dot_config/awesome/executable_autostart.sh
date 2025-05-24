#!/usr/bin/env bash

# Non-GUI things
linux-discord-rich-presence --config ~/Documents/.drpconf &
nm-applet &
blueman-applet &
setxkbmap -model pc105 -layout us\(dvorak\),us -option caps:swapescape,grp:ctrls_toggle; xmodmap -e "keycode 135 = Super_R Super_R"
picom -b

# GUI things (not working, again)
# discord &
# spotify &
# keepassxc &
