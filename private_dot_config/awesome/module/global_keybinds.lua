local gears = require("gears")
local awful = require("awful")
local lockscreen = require("module.lockscreen_simple")
local beautiful = require("beautiful")

-- vim/tmux hotkey popups
require("awful.hotkeys_popup.keys")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Multi-monitor setup
local sharedtags = require("library.sharedtags")

-- Shared tags
local tags = sharedtags({
	{ name = "1", layout = awful.layout.layouts[1] },
	{ name = "2", layout = awful.layout.layouts[1] },
	{ name = "3", layout = awful.layout.layouts[1] },
	{ name = "4", layout = awful.layout.layouts[1] },
	{ name = "7", layout = awful.layout.layouts[1] },
	{ name = "8", layout = awful.layout.layouts[1] },
	{ name = "9", layout = awful.layout.layouts[1] },
	{ name = "0", layout = awful.layout.layouts[1] },
})

globalkeys = gears.table.join(
	-- launch web browser
	awful.key({ modkey }, "b", function()
		awful.util.spawn(browser)
	end, { description = "open browser", group = "launcher" }),

	-- Spotify
	-- TODO add keybinds for spotifyd
	awful.key({ modkey, "Shift" }, "#83", function()
		awful.util.spawn("playerctl -p spotify previous")
	end, { description = "play previous spotify song", group = "media" }),
	awful.key({ modkey, "Shift" }, "#84", function()
		awful.util.spawn("playerctl -p spotify play-pause")
	end, { description = "play/pause spotify song", group = "media" }),
	awful.key({ modkey, "Shift" }, "#85", function()
		awful.util.spawn("playerctl -p spotify next")
	end, { description = "play next spotify song", group = "media" }),
	awful.key({ modkey, "Shift" }, "#80", function()
		awful.util.spawn("playerctl -p spotify volume 0.1+")
	end, { description = "lower spotify volume", group = "media" }),
	awful.key({ modkey, "Shift" }, "#88", function()
		awful.util.spawn("playerctl -p spotify volume 0.1-")
	end, { description = "raise spotify volume", group = "media" }),

	-- TODO brightness (not working)
	awful.key({ modkey }, "F9", function()
		awful.util.spawn_with_shell("xbacklight -inc 10 -ctrl intel_backlight")
	end, { description = "brightness up", group = "screen" }),
	awful.key({ modkey }, "F8", function()
		awful.util.spawn_with_shell("xbacklight -dec 10 -ctrl intel_backlight")
	end, { description = "brightness down", group = "screen" }),
	awful.key({}, "XF86AudioRaiseVolume", function()
		beautiful.volume_widget:inc(5)
	end, { description = "volume down", group = "media" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		beautiful.volume_widget:dec(5)
	end, { description = "volume up", group = "media" }),
	awful.key({}, "XF86AudioMute", function()
		beautiful.volume_widget:toggle()
	end, { description = "toggle mute", group = "media" }),
	awful.key(
		{ modkey },
		"Home",
		lockscreen.debug_mode and lockscreen.toggle_lockscreen or lockscreen.show_lockscreen,
		{ description = "lock screen", group = "client" }
	),
	awful.key({ modkey }, "End", function()
		lockscreen.show_lockscreen()
		awful.util.spawn("systemctl suspend")
	end, { description = "sleep and lock screen", group = "client" }),
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),

	-- Screen keybinds
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	-- Standard program
	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	awful.key({ modkey }, "r", function()
		awful.util.spawn("rofi -show run")
	end, { description = "run rofi launcher", group = "launcher" }),

	awful.key({ modkey }, "space", function()
		awful.util.spawn("rofi -show window")
	end, { description = "run rofi window", group = "client" }),

	awful.key({ modkey, "Shift" }, "s", function()
		awful.util.spawn("flameshot gui")
	end, { description = "take screenshot", group = "client" }),

	-- Toggle systray on all screens (maybe change to focused screen only?)
	-- Also, consider allowing keyboard-only control of systray from here
	awful.key({ modkey }, "=", function()
		beautiful.systray.visible = not beautiful.systray.visible
	end, { description = "toggle systray", group = "screen" })
)

-- Bind all key numbers to tags, skipping the middle 2 (5 and 6).
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1-4 and 7-0.
for i, v in ipairs({ 1, 2, 3, 4, [5] = 7, [6] = 8, [7] = 9, [8] = 10 }) do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. v + 9, function()
			local screen = awful.screen.focused()
			local tag = tags[i]
			if tag then
				-- Non-shared tags
				-- tag:view_only()
				sharedtags.viewonly(tag, screen)
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. v + 9, function()
			local screen = awful.screen.focused()
			local tag = tags[i]
			if tag then
				-- Non-shared tags
				-- awful.tag.viewtoggle(tag)
				sharedtags.viewtoggle(tag, screen)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. v + 9, function()
			if client.focus then
				-- Non-shared tags
				-- local tag = client.focus.screen.tags[i]
				local tag = tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. v + 9, function()
			if client.focus then
				-- Non-shared tags
				-- local tag = client.focus.screen.tags[i]
				local tag = tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

-- Set keys
root.keys(globalkeys)
