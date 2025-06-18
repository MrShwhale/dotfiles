local awful = require("awful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local gears = require("gears")
local awful_table = awful.util.table or gears.table
local keyboardlayout = require("widget.keyboardlayout")

local transparent = "#00000000"

-- Set up the theme variables
-- TODO standarize what you put here
local theme = require("theme.archetypicals.colors")

theme.wallpaper_rotation = false

local backgrounds_dir = os.getenv("HOME") .. "/Pictures/Backgrounds/"
theme.wallpaper = backgrounds_dir .. "SCP/archetypicals_background.png"

theme.lockscreen_background = backgrounds_dir .. "SCP/lockscreen.png"

-- extra widgets
theme.volume_widget = require("awesome-wm-widgets.pactl-widget.volume")
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")

local function selected_arc(cr, width, height, thickness, inner_gap)
	local start_angle = 0
	local end_angle = math.pi * 2

	cr:new_sub_path()

	local radius = math.min(width, height) / 2

	thickness = thickness or radius / 2

	local inner_radius = radius - thickness

	local start_p1 = {
		width / 2,
		height / 2,
	}

	cr:move_to(table.unpack(start_p1))

	cr:arc(width / 2, height / 2, radius, start_angle, end_angle)

	cr:arc_negative(width / 2, height / 2, inner_radius, end_angle, start_angle)

	cr:arc(width / 2, height / 2, inner_radius - inner_gap, start_angle, end_angle)

	cr:close_path()
end

local function set_up_ratio(ratio_list, widget)
	local ratio_sum = 0

	for i, v in ipairs(ratio_list) do
		widget:ajust_ratio(i, ratio_sum, v, 1 - ratio_sum - v)
		ratio_sum = ratio_sum + v
	end
end

local volume_widget = theme.volume_widget({
	widget_type = "icon",
	icon_dir = theme.icon_dir .. "/volume_icons/",
})

local function create_wibar(s)
	s.mypromptbox = awful.widget.prompt()

	s.tasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = awful.util.tasklist_buttons,
	})

	s.taglist = awful.widget.taglist({
		layout = wibox.layout.manual,
		screen = s,
		style = {
			shape_focus = function(cr, width, height)
				selected_arc(cr, width, height, 3, 5)
			end,
		},
		widget_template = {
			{
				id = "index_role",
				widget = wibox.widget.textbox,
			},
			id = "background_role",
			widget = wibox.container.background,
			forced_width = 28,
			forced_height = 28,
			-- Placeholder x value
			point = { x = 0, y = 6 },
			-- Sets the ACTUAL x value
			create_callback = function(self, c3, index, objects)
				self.point = { y = 6, x = 8 * index + 28 * (index - 1) }
			end,
			update_callback = function(self, c3, index, objects)
				self.point = { y = 6, x = 8 * index + 28 * (index - 1) }
			end,
		},
		filter = awful.widget.taglist.filter.all,
		buttons = awful.util.taglist_buttons,
	})

	s.layoutbox = awful.widget.layoutbox(s)
	s.layoutbox:buttons(awful_table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 2, function()
			awful.layout.set(awful.layout.layouts[1])
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))

	local empty_sep = wibox.widget.separator({
		visible = false,
	})

	local textclock = wibox.widget.textclock("%a %b %d %H:%M")
	textclock.halign = "center"
	textclock.valign = "center"
	textclock.font = "Lexend 18"

	local misc_widgets = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		widget = wibox.container.background,
		bg = theme.mantle,
		spacing = 15,
		spacing_widget = {
			color = theme.overlay0,
			widget = wibox.widget.separator,
		},
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 20)
		end,
		shape_clip = true,
		textclock,
		volume_widget,
		keyboardlayout({
			text_color = theme.primary,
			font = "Lexend 18",
		}),
		wibox.widget({
			widget = wibox.container.margin,
			left = dpi(5),
			right = dpi(5),
			battery_widget({
				text_color = theme.primary,
				show_current_level = true,
				path_to_icons = theme.icon_dir .. "/battery_icons/",
				font = "Lexend 18",
			}),
		}),
		s.layoutbox,
	})

	local main_widget = wibox.widget({
		layout = wibox.layout.manual,
		wibox.widget({
			point = { x = 30, y = 10 },
			forced_width = 296,
			forced_height = 40,
			widget = wibox.container.background,
			bg = theme.mantle,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 20)
			end,
			s.taglist,
		}),
		wibox.widget({
			forced_width = 600,
			forced_height = 40,
			point = { x = 660, y = 10 },
			widget = wibox.container.background,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 20)
			end,
			shape_clip = true,
			s.tasklist,
		}),
		wibox.widget({
			widget = wibox.container.background,
			forced_height = 40,
			point = function(geo, args)
				return {
					x = 1920 - 30 - geo.width,
					y = 10,
				}
			end,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 20)
			end,
			bg = theme.mantle,
			wibox.widget({
				widget = wibox.container.margin,
				left = 10,
				right = -28,
				misc_widgets,
			}),
		}),
	})

	-- Create a wibar and add the widgets to it
	s.tag_wibar = awful.wibar({
		screen = s,
		bg = theme.surface1,
	})

	s.tag_wibar:setup({
		widget = wibox.container.margin,
		main_widget,
	})
end

function theme.at_screen_connect(s)
	create_wibar(s)
end

-- Setting up the actual systray
theme.systray = wibox({
	visible = false,
	-- I hate it here
	-- TODO fix this sizing stuff
	x = awful.screen:focused().geometry.width * 0.75 - 3,
	y = awful.screen:focused().geometry.y + 90,
	bg = "#00000000",
	width = awful.screen:focused().geometry.width * 0.25,
	height = 70,
	ontop = true,
})

theme.systray:setup({
	layout = wibox.layout.manual,
	wibox.widget({
		widget = wibox.container.margin,
		bg = transparent,
		margins = dpi(7),
		{
			widget = wibox.container.background,
			bg = theme.surface1,
			shape = function(cr, width, height)
				gears.shape.rounded_rect(cr, width, height, 2)
			end,
			shape_clip = true,
			{
				widget = wibox.widget.systray(true),
			},
		},
	}),
})

return theme
