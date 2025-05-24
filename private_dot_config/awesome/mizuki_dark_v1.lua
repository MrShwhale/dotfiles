local awful              = require("awful")
local xresources         = require("beautiful.xresources")
local dpi                = xresources.apply_dpi
local wibox              = require("wibox")
local gears              = require("gears")
local awful_table        = awful.util.table or gears.table -- 4.{0,1} compatibility

local transparent        = "#00000000"

-- Set up the theme variables
-- TODO standarize what you put here
local theme              = require("mizuki_dark_v1_c")

theme.wallpaper_rotation = true

local backgrounds_dir    = os.getenv("HOME") .. "/Pictures/Backgrounds/"
theme.wallpaper          = backgrounds_dir .. "/normal/dark/"
theme.alt_wallpaper      = backgrounds_dir .. "/sekai/mizuki/"

-- extra widgets
theme.volume_widget      = require('awesome-wm-widgets.pactl-widget.volume')
local batteryarc_widget  = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

local function double_border(inner_widget, rect_rad, inner_border_width, outer_border_width, intra_border_space)
    local function double_shape(rad)
        return function(cr, width, height) gears.shape.rounded_rect(cr, width, height, rad) end
    end

    return
    {
        widget = wibox.container.background,
        shape = double_shape(rect_rad),
        shape_border_width = dpi(outer_border_width),
        shape_clip = true,
        {
            widget = wibox.container.margin,
            margins = dpi(intra_border_space),
            bg = transparent,
            {
                widget = wibox.container.background,
                shape = double_shape(math.max(rect_rad - intra_border_space, 0)),
                shape_border_width = dpi(inner_border_width),
                shape_clip = true,
                inner_widget,
                bg = theme.bg_normal .. "55"
            }
        }
    }
end

local function set_up_ratio(ratio_list, widget)
    local ratio_sum = 0

    for i, v in ipairs(ratio_list) do
        widget:ajust_ratio(i, ratio_sum, v, 1 - ratio_sum - v)
        ratio_sum = ratio_sum + v
    end
end

local function std_double(widget)
    return double_border(widget, 5, 3, 3, 7)
end

local function create_wibar(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    s.layoutbox = awful.widget.layoutbox(s)
    s.layoutbox:buttons(awful_table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 2, function() awful.layout.set(awful.layout.layouts[1]) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))

    s.taglist = awful.widget.taglist {
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = awful.util.taglist_buttons,
    }

    s.tasklist = awful.widget.tasklist {
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = awful.util.tasklist_buttons
    }

    s.systray_icon = wibox.widget {
        widget = wibox.widget.imagebox,
        image = theme.dir .. "/icons/menu_wp.png",
        resize = true,
    }

    s.systray_icon:buttons(awful_table.join(
        awful.button({}, 1,
            function()
                theme.systray.visible = not theme.systray.visible
            end)
    ))

    local statusline = wibox.widget {
        layout = wibox.layout.ratio.horizontal,
        -- TODO consider making these yourself for better customization
        wibox.widget {
            widget = wibox.container.background,
            fg = "#c5c5d6",
            wibox.widget.textclock(),
        },
        wibox.widget {
            widget = wibox.container.background,
            fg = "#c5c5d6",
            awful.widget.keyboardlayout:new(),
        },
        batteryarc_widget { show_current_level = true, arc_thickness = 5, font = "Lexend 11", main_color = "#c5c5d6" },
        theme.volume_widget { widget_type = "icon", main_color = "#c5c5d6" },
        s.systray_icon,
        s.layoutbox,
    }

    local status_widgets = { 0.35, 0.25, 0.1, 0.1, 0.1, 0.1 }
    set_up_ratio(status_widgets, statusline)

    theme.taglist_bg_occupied = "#454654" .. theme.wibar_element_transparency
    theme.taglist_fg_occupied = "#c5c5d6" .. theme.wibar_element_transparency
    local main_widget = wibox.widget {
        layout = wibox.layout.ratio.horizontal,
        std_double(wibox.widget {
            widget = wibox.container.margin,
            bg = transparent,
            margins = dpi(7),
            s.taglist
        }),
        wibox.widget { widget = wibox.widget.separator, visible = false },
        std_double(wibox.widget {
            widget = wibox.container.margin,
            bg = transparent,
            margins = dpi(7),
            {
                widget = wibox.container.background,
                shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 2) end,
                shape_clip = true,
                s.tasklist
            }
        }),
        wibox.widget { widget = wibox.widget.separator, visible = false },
        std_double(wibox.widget {
            widget = wibox.container.margin,
            bg = transparent,
            margins = dpi(7),
            {
                widget = wibox.container.background,
                bg = "#454654",
                shape = function(cr, width, height) gears.shape.rounded_rect(cr, width, height, 2) end,
                shape_clip = true,
                statusline
            }
        }),
    }

    local main_ratios = { .26, .09, .30, .09, .26 }
    set_up_ratio(main_ratios, main_widget)

    -- Create a wibar and add the widgets to it
    s.tag_wibar = awful.wibar({
        screen = s,
        bg = transparent,
    })

    s.tag_wibar:setup {
        widget = wibox.container.margin,
        bottom = dpi(3),
        left = dpi(6),
        right = dpi(6),
        top = dpi(7),
        main_widget
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
    std_double(wibox.widget {
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
    }),
}

return theme
