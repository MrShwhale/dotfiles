local awful              = require("awful")
local xresources         = require("beautiful.xresources")
local dpi                = xresources.apply_dpi
local wibox              = require("wibox")
local gears              = require("gears")
local awful_table        = awful.util.table or gears.table -- 4.{0,1} compatibility
local keyboardlayout     = require("keyboardlayout")

-- For cairo things
local unpack             = table.unpack -- luacheck: globals unpack (compatibility with Lua 5.1)

local transparent        = "#00000000"

-- Set up the theme variables
-- TODO standarize what you put here
local theme              = require("mizuki_darker_v2_c")

theme.wallpaper_rotation = false

local backgrounds_dir    = os.getenv("HOME") .. "/Pictures/Backgrounds/"
theme.wallpaper          = backgrounds_dir .. "Landscapes/purple_water.jpg"
theme.alt_wallpaper      = backgrounds_dir .. "sekai/mizuki/117_at.png"

-- extra widgets
theme.volume_widget      = require('awesome-wm-widgets.pactl-widget.volume')
local battery_widget     = require("awesome-wm-widgets.battery-widget.battery")

local function selected_arc(cr, width, height, thickness, inner_gap)
    local start_angle = 0
    local end_angle   = math.pi * 2

    cr:new_sub_path()

    local radius = math.min(width, height) / 2

    thickness = thickness or radius / 2

    local inner_radius = radius - thickness

    local start_p1 = {
        width / 2,
        height / 2
    }

    cr:move_to(unpack(start_p1))

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

local volume_widget = theme.volume_widget {
    widget_type = "icon",
    icon_dir = theme.icon_dir .. "/volume_icons/",
}

local function create_wibar(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    s.tasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons
    }

    s.taglist = awful.widget.taglist {
        layout  = wibox.layout.flex.horizontal,
        screen  = s,
        style   = {
            shape_focus = function(cr, width, height) selected_arc(cr, width, height, 5, 7) end
        },
        filter  = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
    }

    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(awful_table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))

    local function create_misc_container(widget)
        return wibox.widget {
            widget = wibox.container.background,
            bg = theme.surface_variant,
            shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 10) end,
            wibox.widget {
                widget = wibox.container.margin,
                widget,
            }
        }
    end

    local empty_sep = wibox.widget.separator {
        visible = false
    }

    local textclock = wibox.widget.textclock('%a %b %d %H:%M')
    textclock.halign = "center"
    textclock.valign = "center"
    textclock.font = "Lexend 18"

    -- TODO also center everything in their boxes
    local misc_widgets =
        wibox.widget {
            layout = wibox.layout.ratio.horizontal,
            widget = wibox.container.background,
            bg = transparent,
            create_misc_container(
                wibox.widget {
                    widget = wibox.container.margin,
                    left = dpi(5),
                    s.layoutbox
                }),
            empty_sep,
            create_misc_container(
                wibox.widget {
                    widget = wibox.container.background,
                    fg = theme.on_surface_variant,
                    textclock
                }),
            empty_sep,
            create_misc_container(volume_widget),
            empty_sep,
            create_misc_container(
                wibox.widget {
                    widget = wibox.container.background,
                    fg = theme.on_surface_variant,
                    layout = wibox.layout.flex.horizontal,
                    wibox.widget {
                        widget = wibox.widget.imagebox,
                        image = theme.icon_dir .. "/keyboard.svg",
                        resize = true
                    },
                    keyboardlayout {
                        text_color = theme.on_surface_variant,
                        font = "Lexend 18"
                    },
                }),
            empty_sep,
            create_misc_container(
                wibox.widget {
                    widget = wibox.container.margin,
                    left = dpi(5),
                    right = dpi(5),
                    battery_widget {
                        text_color = theme.on_surface_variant,
                        show_current_level = true,
                        path_to_icons = theme.icon_dir .. "/battery_icons/",
                        font = "Lexend 18",
                    }
                })
        }

    local misc_ratios = { .09, .018, .40, .018, .1, .018, .16, .018, .18 }
    set_up_ratio(misc_ratios, misc_widgets)

    local main_widget = wibox.widget {
        layout = wibox.layout.ratio.horizontal,
        wibox.widget {
            widget = wibox.container.margin,
            bg = transparent,
            left = dpi(7),
            top = dpi(7),
            bottom = dpi(7),
            {
                widget = wibox.container.background,
                shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 8) end,
                shape_clip = true,
                s.tasklist
            }
        },
        wibox.widget { widget = wibox.widget.separator, visible = false },
        s.taglist,
        wibox.widget { widget = wibox.widget.separator, visible = false },
        wibox.widget {
            widget = wibox.container.margin,
            bg = transparent,
            right = dpi(7),
            top = dpi(7),
            bottom = dpi(7),
            misc_widgets
        }
    }

    local main_ratios = { .3, .095, .21, .095, .3 }
    set_up_ratio(main_ratios, main_widget)

    -- Create a wibar and add the widgets to it
    s.tag_wibar = awful.wibar({
        screen = s,
        bg = transparent,
    })

    s.tag_wibar:setup {
        widget = wibox.container.margin,
        bottom = dpi(7),
        left = dpi(10),
        right = dpi(10),
        top = dpi(10),
        wibox.widget {
            widget = wibox.container.background,
            bg = "#00000099",
            shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 15) end,
            visible = true,
            main_widget
        }
    }
end

function theme.at_screen_connect(s)
    create_wibar(s)
end

-- Setting up the actual systray
theme.systray = wibox {
    visible = false,
    -- I hate it here
    -- TODO fix this sizing stuff
    x = awful.screen:focused().geometry.width * 0.75 - 3,
    y = awful.screen:focused().geometry.y + 90,
    bg = "#00000000",
    width = awful.screen:focused().geometry.width * 0.25,
    height = 70,
    ontop = true
}

theme.systray:setup {
    layout = wibox.layout.manual,
    wibox.widget {
        widget = wibox.container.margin,
        bg = transparent,
        margins = dpi(7),
        {
            widget = wibox.container.background,
            bg = "#454654",
            shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 2) end,
            shape_clip = true,
            {
                widget = wibox.widget.systray(true)
            }
        }
    },
}

return theme
