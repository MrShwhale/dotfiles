local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")
local config_dir = gears.filesystem.get_configuration_dir()

-- Load fallback config if needed
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Startup error",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Runtime error",
			text = tostring(err),
		})
		in_error = false
	end)
end

beautiful.init(config_dir .. "theme/archetypicals/theme.lua")

-- Make sure randomness is not repeated
math.randomseed(os.time())

awful.util.shell = "sh"
terminal = "kitty"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor
browser = "zen-browser"
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.floating,
}

naughty.config.defaults["icon_size"] = 100
