-- This file starts all of the things I need
-- Prefer this over other autostart files, since I can use more specific awesomewm things
-- Will eventually support adding stuff to specific tags on startup
local awful = require("awful")

-- SUS I removed all of the background (&) things
-- However, picom is still run with -b
local process = {
	-- "spotify",
	-- "keepassxc",
	-- "discord",
	"linux-discord-rich-presence --config ~/Documents/.drpconf &",
	"nm-applet &",
	"blueman-applet &",
	"picom -b",
	'setxkbmap -model pc105 -layout us\\(dvorak\\),us -option caps:swapescape,grp:ctrls_toggle; xmodmap -e "keycode 135 = Super_R Super_R" &',
}

-- SUS this just... didn't work
-- Launch all the easy stuff
for _, app in ipairs(process) do
	-- local naughty = require("naughty")
	-- naughty.notify({
	-- 	title = "Starting app",
	-- 	text = app,
	-- })
	awful.spawn.once(app)
end
