local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
-- When geometry is changed then reset wallpaper
-- TODO find out if this should be fixed
-- screen.connect_signal("property::geometry", set_wallpaper)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    -- Titlebars iff layout is floating
    if c.floating and not (c.maximized or c.maximized_vertical or c.maximized_horizontal) then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup {
        {
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Only enable titlebars when floating and not maximized
client.connect_signal("property::floating", function(c)
    if c.floating and not (c.maximized or c.maximized_vertical or c.maximized_horizontal) then
        awful.titlebar.show(c)
    else
        awful.titlebar.hide(c)
    end
end)

-- Add titlebars to windows when layout is switched to floating
tag.connect_signal("property::layout", function(t)
    local clients = t:clients()
    for k, c in pairs(clients) do
        if ((c.floating or c.first_tag.layout.name == "floating") and not (c.maximized or c.maximized_vertical or c.maximized_horizontal)) then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
end)

-- Set focus border when client is focused, remove it when client not focused anymore
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

client.connect_signal("request::activate", function(c)
    -- If this client is hidden, unhide it when asked
    c.hidden = false
end)
