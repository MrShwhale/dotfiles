local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local lockscreen = require("module.lockscreen_simple")

-- Widget and layout library
local wibox = require("wibox")

local wallpaper_ind = 1
local function set_up_wallpaper()
	-- Load standard wallpapers
	if beautiful.wallpaper then
		-- If this is a directory, then go through it
		if gears.filesystem.is_dir(beautiful.wallpaper) then
			wallpaper_ind = 0
			beautiful.wallpapers = {}
			-- TODO DO NOT USE IO POPEN LITERALLY HOW IS THIS IN YOUR CODE YOU BUFFOON
			for image in io.popen("ls -pa " .. beautiful.wallpaper .. " | grep -v /"):lines() do
				wallpaper_ind = wallpaper_ind + 1
				beautiful.wallpapers[wallpaper_ind] = image
			end
		else
			beautiful.wallpapers = { beautiful.wallpaper }
		end
	end

	-- Choose a random wallpaper
	wallpaper_ind = math.random(#beautiful.wallpapers)
end

set_up_wallpaper()

local function set_wallpaper(s)
	-- Make sure that wallpaper_ind is in range
	-- Assumes that wallpapers is set correctly (a list of files which exist in
	-- TODO look at the git release default config for a better version of this?
	wallpaper_ind = wallpaper_ind >= #beautiful.wallpapers and 1 or wallpaper_ind + 1

	awful.wallpaper({
		screen = s,
		widget = {
			widget = wibox.widget.imagebox,
			image = beautiful.wallpapers[wallpaper_ind],
			resize = true,
			-- This stretches the images, but it isn't noticeable to your uncultured eyes
			horizontal_fit_policy = "fit",
			vertical_fit_policy = "fit",
		},
	})
end

-- Start the wallpaper rotation timer
gears.timer({
	timeout = 900, -- 15 mins in seconds
	autostart = true,
	call_now = false,
	callback = function()
		for s in screen do
			s:emit_signal("request::wallpaper")
		end
	end,
})

-- Sets up the wallpaper and wibar
awful.screen.connect_for_each_screen(function(s)
	beautiful.at_screen_connect(s)
	lockscreen.set_up_lockscreen(s)
end)

screen.connect_signal("request::wallpaper", set_wallpaper)
