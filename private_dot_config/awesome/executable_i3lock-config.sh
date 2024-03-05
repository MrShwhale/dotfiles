#!/bin/bash
# Script from Andrea Fortuna (https://andreafortuna.org/2020/04/09/i3-how-to-make-a-pretty-lock-screen-with-a-four-lines-of-bash-script/)
# create a temp file
img=$(mktemp /tmp/XXXXXXXXXX.png)
# Take a screenshot of current desktop
import -window root $img 
# Pixelate the screenshot
convert $img -scale 10% -scale 1000% $img
# Alternatively, blur the screenshot (slow!)
#convert $img -blur 2,5 $img

# Run i3lock with custom background and customization
i3lock -i $img -e --indicator --radius 100 \
    --noinput-text="" --lock-text="initiating lock" --lockfailed-text="lock failed" --greeter-text="" --verif-text="checking..." --wrong-text="wrong" \
    --separator-color=414868 --keyhl-color=bb9af7 --bshl-color=D90077 --ring-color=f7768e --line-color=24283b --inside-color=24283b 
    
# Remove the tmp file
rm $img
