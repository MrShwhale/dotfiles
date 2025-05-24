-- Thanks to https://github.com/eromatiya/the-glorious-dotfiles for the cool organization setup
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Multi-monitor setup
local sharedtags = require("sharedtags")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")

-- Fancy stuff library
local lain = require("lain")

-- vim/tmux hotkey popups
require("awful.hotkeys_popup.keys")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Custom lockscreen
local lockscreen = require("lockscreen")

-- Make sure randomness is not repeated
math.randomseed(os.time())

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Startup error",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Runtime error",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions

local config_dir = gears.filesystem.get_configuration_dir()
beautiful.init(config_dir .. "mizuki_darker_v2.lua")

-- These all need to be global I think
terminal = "kitty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
browser = "zen-browser"

-- Default modkey (windows key).
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

-- Shared tags
local tags = sharedtags({
    { name = "MAIN",  layout = awful.layout.layouts[1] },
    { name = "ALT",   layout = awful.layout.layouts[1] },
    { name = "AUX",   layout = awful.layout.layouts[1] },
    { name = "SPARE", layout = awful.layout.layouts[1] },
    { name = "NOTE",  layout = awful.layout.layouts[1] },
    { name = "MISC",  layout = awful.layout.layouts[1] },
    { name = "MEDIA", layout = awful.layout.layouts[1] },
    { name = "MUSIC", layout = awful.layout.layouts[1] },
})

naughty.config.defaults['icon_size'] = 100
-- }}}

-- {{{ Misc setup

local wallpaper_ind = 1
local function set_up_wallpaper()
    -- Load standard wallpapers
    if beautiful.wallpaper then
        -- If this is a directory, then go through it
        if gears.filesystem.is_dir(beautiful.wallpaper) then
            wallpaper_ind = 0
            beautiful.main_wallpapers = {}
            -- TODO DO NOT USE IO POPEN LITERALLY HOW IS THIS IN YOUR CODE YOU BUFFOON
            for image in io.popen("ls -pa " .. beautiful.wallpaper .. " | grep -v /"):lines() do
                wallpaper_ind = wallpaper_ind + 1
                beautiful.main_wallpapers[wallpaper_ind] = image
            end
        else
            beautiful.main_wallpapers = { beautiful.wallpaper }
        end
    end


    -- Load alternate wallpapers
    if beautiful.alt_wallpaper then
        -- If this is a directory, then go through it
        if gears.filesystem.is_dir(beautiful.alt_wallpaper) then
            wallpaper_ind = 0
            beautiful.alternate_wallpapers = {}
            -- TODO DO NOT USE IO POPEN LITERALLY HOW IS THIS IN YOUR CODE YOU BUFFOON
            for image in io.popen("ls -pa " .. beautiful.alt_wallpaper .. " | grep -v /"):lines() do
                wallpaper_ind = wallpaper_ind + 1
                beautiful.alternate_wallpapers[wallpaper_ind] = image
            end
        else
            beautiful.alternate_wallpapers = { beautiful.alt_wallpaper }
        end
    end

    -- Set main as the default wallpapers
    beautiful.is_main_wall = true
    beautiful.wallpapers = beautiful.main_wallpapers

    -- Choose a random wallpaper
    wallpaper_ind = math.random(#beautiful.wallpapers)
end

set_up_wallpaper()

local function set_wallpaper(s)
    -- Make sure that wallpaper_ind is in range
    -- Assumes that wallpapers is set correctly (a list of files which exist in
    -- TODO look at the git release default config for a better version of this?
    wallpaper_ind = wallpaper_ind >= #beautiful.wallpapers and 1 or wallpaper_ind + 1

    awful.wallpaper {
        screen = s,
        widget = {
            widget = wibox.widget.imagebox,
            image = beautiful.wallpapers[wallpaper_ind],
            resize = true,
            -- This stretches the images, but it isn't noticeable to your uncultured eyes
            horizontal_fit_policy = "fit",
            vertical_fit_policy = "fit",
        }
    }
end

-- }}}

-- {{{ Wibar
-- Sets up the wallpaper and wibar
awful.screen.connect_for_each_screen(function(s)
    beautiful.at_screen_connect(s)
    lockscreen.set_up_lockscreen(s)
end)

-- }}}

-- {{{ key bindings
globalkeys = gears.table.join(

    -- missioncenter
    awful.key({ modkey, "Control" }, "s", function() quake_mission:toggle() end,
        { description = "open missioncenter", group = "launcher" }),

    -- launch web browser
    awful.key({ modkey }, "b", function() awful.util.spawn(browser) end,
        { description = "open browser", group = "launcher" }),

    -- Spotify
    -- TODO add keybinds for spotifyd
    awful.key({ modkey, "Shift" }, "#83", function() awful.util.spawn("playerctl -p spotify previous") end,
        { description = "play previous spotify song", group = "media" }),
    awful.key({ modkey, "Shift" }, "#84", function() awful.util.spawn("playerctl -p spotify play-pause") end,
        { description = "play/pause spotify song", group = "media" }),
    awful.key({ modkey, "Shift" }, "#85", function() awful.util.spawn("playerctl -p spotify next") end,
        { description = "play next spotify song", group = "media" }),
    awful.key({ modkey, "Shift" }, "#80", function() awful.util.spawn("playerctl -p spotify volume 0.1+") end,
        { description = "lower spotify volume", group = "media" }),
    awful.key({ modkey, "Shift" }, "#88", function() awful.util.spawn("playerctl -p spotify volume 0.1-") end,
        { description = "raise spotify volume", group = "media" }),

    -- TODO brightness (not working)
    awful.key({ modkey }, "F9", function() awful.util.spawn_with_shell("xbacklight -inc 10 -ctrl intel_backlight") end,
        { description = 'brightness up', group = 'screen' }),
    awful.key({ modkey }, "F8", function() awful.util.spawn_with_shell("xbacklight -dec 10 -ctrl intel_backlight") end,
        { description = 'brightness down', group = 'screen' }),
    awful.key({}, "XF86AudioRaiseVolume", function() beautiful.volume_widget:inc(5) end,
        { description = 'volume down', group = 'media' }),
    awful.key({}, "XF86AudioLowerVolume", function() beautiful.volume_widget:dec(5) end,
        { description = 'volume up', group = 'media' }),
    awful.key({}, "XF86AudioMute", function() beautiful.volume_widget:toggle() end,
        { description = 'toggle mute', group = 'media' }),
    awful.key({ modkey, }, "Home", lockscreen.debug_mode and lockscreen.toggle_lockscreen or lockscreen.show_lockscreen,
        { description = "lock screen", group = "client" }),
    awful.key({ modkey, }, "End", function()
            lockscreen.show_lockscreen(); awful.util.spawn("systemctl suspend")
        end,
        { description = "sleep and lock screen", group = "client" }),
    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    -- Swaps between different wallpaper sets
    awful.key({ modkey, "Shift" }, "'", function()
            if beautiful.is_main_wall then
                beautiful.wallpapers = beautiful.alternate_wallpapers
                beautiful.is_main_wall = false
            else
                beautiful.wallpapers = beautiful.main_wallpapers
                beautiful.is_main_wall = true
            end

            wallpaper_ind = math.random(#beautiful.wallpapers)

            for s in screen do
                s:emit_signal("request::wallpaper")
            end
        end,
        { description = "swap wallpapers", group = "screen" }),

    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),

    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),

    -- Screen keybinds
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    awful.key({ modkey }, "r", function()
            awful.util.spawn("rofi -show run")
        end,
        { description = "run rofi launcher", group = "launcher" }),

    awful.key({ modkey }, "space", function()
            awful.util.spawn("rofi -show window")
        end,
        { description = "run rofi window", group = "client" }),

    awful.key({ modkey, "Shift" }, "s", function()
            awful.util.spawn("flameshot gui")
        end,
        { description = "take screenshot", group = "client" }),

    -- Toggle systray on all screens (maybe change to focused screen only?)
    -- Also, consider allowing keyboard-only control of systray from here
    awful.key({ modkey }, "=", function()
            beautiful.systray.visible = not beautiful.systray.visible
        end,
        { description = "toggle systray", group = "screen" })
)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            -- This code makes fullscreen works, but means that when you unfullscreen a program it won't be maximized anymore
            c.maximized = not c.fullscreen
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
        { description = "close", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "k", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" }),
    -- TODO somehow fix this still showing as nonempty tags
    awful.key({ modkey, }, "z",
        function(c)
            c.skip_taskbar = false
            c.hidden = true
            c.minimized = false
        end,
        { description = "hide", group = "client" })
)

-- Bind all key numbers to tags, skipping the middle 2 (5 and 6).
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1-4 and 7-0.
for i, v in ipairs({ 1, 2, 3, 4, [5] = 7, [6] = 8, [7] = 9, [8] = 10 }) do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. v + 9,
            function()
                local screen = awful.screen.focused()
                local tag = tags[i]
                if tag then
                    -- Non-shared tags
                    -- tag:view_only()
                    sharedtags.viewonly(tag, screen)
                end
            end,
            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. v + 9,
            function()
                local screen = awful.screen.focused()
                local tag = tags[i]
                if tag then
                    -- Non-shared tags
                    -- awful.tag.viewtoggle(tag)
                    sharedtags.viewtoggle(tag, screen)
                end
            end,
            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. v + 9,
            function()
                if client.focus then
                    -- Non-shared tags
                    -- local tag = client.focus.screen.tags[i]
                    local tag = tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. v + 9,
            function()
                if client.focus then
                    -- Non-shared tags
                    -- local tag = client.focus.screen.tags[i]
                    local tag = tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        -- BUG: First condition only works on clients marked floating, not those on floating layouts
        -- If a layout which enforces floating which is not the default floating, this will not work
        if c.floating or awful.layout.get(c.screen) == awful.layout.suit.floating then
            c:emit_signal("request::activate", "mouse_click", { raise = true })
            awful.mouse.client.resize(c)
        end
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }, -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA",   -- Firefox addon DownThemAll.
                "copyq", -- Includes session name in class.
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "hollow_knight.x86_64",
                "Kruler",
                "libTAS",
                "MessageWin", -- kalarm.
                "ruffle",
                "Sxiv",
                "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester", -- xev.
            },
            role = {
                "AlarmWindow",   -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up",        -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    ---[[ Remove titlebars from normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false }
    },
    --]]
}
-- }}}

-- {{{ Signals
-- When geometry is changed then reset wallpaper
-- TODO find out if this should be fixed
-- screen.connect_signal("property::geometry", set_wallpaper)

screen.connect_signal("request::wallpaper", set_wallpaper)

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

-- }}}

-- Start the rotation timer
gears.timer {
    timeout = 900, -- 15 mins in seconds
    autostart = true,
    call_now = false,
    callback = function()
        for s in screen do
            s:emit_signal("request::wallpaper")
        end
    end
}

-- Autostart (comment out for dev stuff)
awful.spawn.once(config_dir .. "autostart.sh")
