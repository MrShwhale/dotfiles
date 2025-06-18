-- Importing libraries
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

-- TODO Add ALL the config to theme variables
-- (this should NOT be based on this file, why did you think this)

-- PAM library must be installed
-- CONS add fallback password
-- CONS add fallback notification/boolean to return table
local config_dir = gears.filesystem.get_configuration_dir()
package.cpath = package.cpath .. ";" .. config_dir .. "/library/?.so;" .. "/usr/lib/lua-pam/?.so;"
local pam = require("liblua_pam")

local lockscreen = {}
lockscreen.debug_mode = false

-- CONS redo this whole file based on screen percentage instead of pixels

-- {{{ Image paths

-- Image to make the lockscreen background
-- CONS adding the ability to generate from command, for screenshot
-- CONS add swap capabilities
local lockscreen_background = os.getenv("HOME") .. "/Pictures/Backgrounds/SCP/lockscreen.png"
-- }}}

-- Lockscreen keygrabber
local ls_keygrabber

-- Fake password to be displayed as the real is typed
local fake_pass = "theblackmoonhowls"

-- Default password text
-- Do not delete ellipsis, it makes everything work... sigh
local def_pass = "…  " .. '<span foreground="#808080">AUTHENTICATE</span>'

-- List that stores user input
local input = {}

-- Forward declarations of internal functions
local handle_pressed, try_login, update_textbox

-- {{{ Utils

-- Check if a character can be put into a password
-- This, for my purposes, is all printable ASCII characters except for enter and tab
local function is_passwordable(char)
	-- Only valid multichar name is Space
	if char == "Space" then
		return true
	end

	if #char == 1 then
		local val = string.byte(char)
		if val > 31 and val < 127 then
			return true
		end
	end

	return false
end

-- Don't show notification popups if the screen is locked
local function check_lockscreen_visibility()
	local focused = awful.screen.focused()
	if focused.lockscreen and focused.lockscreen.visible then
		return true
	end
	return false
end

-- }}}

-- {{{ Lockscreen creation
-- Create a lockscreen on this screen
local function create_input(lockbox_color, s)
	-- This 15 is roughly the number of pixels in this font at this size on this screen it takes to hide an ellipsis and 2 spaces
	-- "So hardcoded it hurts"
	local input_shape = gears.shape.transform(gears.shape.rectangle):translate(15, 0)

	local input_text = wibox.widget({
		widget = wibox.widget.textbox,
		markup = def_pass,
		ellipsize = "start",
		font = "Lexend 20",
	})

	local input_box = wibox.widget({
		widget = wibox.container.background,
		bg = lockbox_color,
		fg = "#000000FF",
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 35)
		end,
		point = { x = s.geometry.x + 775, y = s.geometry.y + 670 },
		forced_width = 370,
		forced_height = 60,
		wibox.widget({
			widget = wibox.container.margin,
			right = 20,
			wibox.widget({
				widget = wibox.container.background,
				forced_width = 370 - 100,
				-- shape_border_width = 2,
				shape_clip = true,
				border_color = "#000000",
				shape = input_shape,
				input_text,
			}),
		}),
	})

	return input_box, input_text
end

local function create_images(s, lockbox_color)
	local lockscreen_bg_image = gears.surface.load(lockscreen_background)

	local background_widget = wibox.widget({
		widget = wibox.widget.imagebox,
		image = lockscreen_bg_image,
		forced_width = s.geometry.width,
		forced_height = s.geometry.height,
		resize = true,
		-- Stretch works since it is blurry and not that far off
		-- Might need to change at some point
		horizontal_fit_policy = "fit",
		vertical_fit_policy = "fit",
	})
	return background_widget
end

local function create_lockscreen(s)
	-- Lockscreen is simply a full-screen wibox
	s.lockscreen = wibox({
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height,
		visible = false,
		ontop = true,
	})

	local lockbox_color = "#D3D3D3D9"

	local background_widget = create_images(s, lockbox_color)

	-- CONS make this not terrible
	local input_box, input_text = create_input(lockbox_color, s)
	s.lockscreen.input_text = input_text

	local ls_keybindings = {}

	-- Add all english printable characters

	ls_keygrabber = awful.keygrabber({
		keybindings = ls_keybindings,
		keypressed_callback = handle_pressed,
	})

	if lockscreen.debug_mode then
		ls_keygrabber.timeout = 10
	end

	s.lockscreen:setup({
		layout = wibox.layout.manual,
		background_widget,
		input_box,
	})
end

-- }}}

-- {{{ Internal functions

-- Update the characters printed in each of the textboxes
update_textbox = function()
	-- Create string to replace input with
	local passtext
	local fake_len = utf8.len(fake_pass)

	-- If the input is empty, use the default
	if #input == 0 then
		passtext = def_pass
	else
		-- Slice the fake pass
		-- Harder than it needs to be because of Unicode
		passtext = "…  "
			.. string.rep(fake_pass, math.floor(#input / fake_len))
			.. fake_pass:sub(1, utf8.offset(fake_pass, math.fmod(#input, fake_len) + 1) - 1)
	end

	for s in screen do
		-- Set the text
		s.lockscreen.input_text.markup = passtext
	end
end

-- Attempt to log the user in
try_login = function()
	-- Adds a permanent 0.05 second delay
	-- Might take out/reduce, but I like seeing the thinking even on a correct pass
	-- I also like seeing it at all, which this allows
	gears.timer({
		timeout = 0.05,
		autostart = true,
		single_shot = true,
		callback = function()
			if pam.auth_current_user(table.concat(input)) then
				lockscreen.close_lockscreen()
			end

			-- Remove the input
			input = {}
			update_textbox()
		end,
	})
end

-- Handle the user pressing keys
handle_pressed = function(self, mod, key, event)
	if is_passwordable(key) then
		-- Add it to the end of the input
		local keychar = key == "Space" and " " or key
		input[#input + 1] = keychar
	elseif key == "Return" then
		try_login()
		-- return
	elseif key == "Escape" then
		-- Delete the whole array, condition to avoid redraw
		if #input > 0 then
			input = {}
		else
			return
		end
	elseif key == "BackSpace" then
		-- Delete the last character, if possible
		if #input > 0 then
			input[#input] = nil
		else
			return
		end
	else
		return
	end

	update_textbox()
end

-- }}}

-- {{{ External functions

-- Run the lockscreen on all screens
function lockscreen.show_lockscreen()
	for s in screen do
		s.lockscreen.visible = true
	end

	-- Clear old input
	update_textbox()

	-- Stop existing keybindings and start our own keybindings
	ls_keygrabber:start()

	-- No notifications while locked
	if not lockscreen.debug_mode then
		naughty.suspend()
	end
end

-- Stop running the lockscreen on all screens
function lockscreen.close_lockscreen()
	for s in screen do
		s.lockscreen.visible = false
	end

	ls_keygrabber:stop()

	-- Notifications can come back now
	if not lockscreen.debug_mode then
		naughty.resume()
	end
end

-- Take all needed actions to make a lockscreen for the given screen
-- Right now, just makes the screen, but could later have commands run, etc.
function lockscreen.set_up_lockscreen(s)
	create_lockscreen(s)
end

-- DEBUG ONLY
-- Doesn't work when the keygrabber is running (obv)
function lockscreen.toggle_lockscreen()
	if check_lockscreen_visibility() then
		lockscreen.close_lockscreen()
	else
		lockscreen.show_lockscreen()
	end
end

-- }}}

return lockscreen
