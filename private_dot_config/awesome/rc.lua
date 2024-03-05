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
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local lain          = require("lain")
--local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup")
                      require("awful.hotkeys_popup.keys")
local mytable       = awful.util.table or gears.table -- 4.{0,1} compatibility

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
awesome_config_dir = "/home/will/.config/awesome/"
beautiful.init(awesome_config_dir .. "theme.lua")

--[[
for i,v in pairs(table_here) do
    if type(v) == "function" then
        print(i,v,debug.getinfo(v))
    end
end
--]]

-- This is used later as the default terminal and editor to run.
terminal = "warp-terminal"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
browser = "vivaldi-stable"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Tags
local tags = sharedtags({
    {name = "PRIMARY", layout = awful.layout.layouts[1] },
    {name = "SECONDARY", layout = awful.layout.layouts[1] },
    {name = "TERTIARY", layout = awful.layout.layouts[1] },
    {name = "DOCS", layout = awful.layout.layouts[1] },
    {name = "NOTES", layout = awful.layout.layouts[1] },
    {name = "MISC", layout = awful.layout.layouts[1] },
    {name = "MEDIA", layout = awful.layout.layouts[1] },
    {name = "MUSIC", layout = awful.layout.layouts[1] }
})
-- }}}

-- Wallpaper management is through nitrogen
local function set_wallpaper(s)
    awful.spawn("nitrogen --restore")
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

---[[ {{{ Wibar

-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Keyboard map indicator and switcher
local keyboardlayout = awful.widget.keyboardlayout:new()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
awful.button({ }, 1, function (c)
    if c == client.focus then
        c.minimized = true
    else
        c:emit_signal(
        "request::activate",
        "tasklist",
        {raise = true}
        )
    end
end),
awful.button({ }, 3, function()
    awful.menu.client_list({ theme = { width = 250 } })
end),
awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
end),
awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
end))

awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s)
    
    -- wibar things in here, stolen from powerarrow theme
    beautiful.at_screen_connect(s)
end)
-- }}} ]]

-- {{{ mouse bindings
root.buttons(gears.table.join(
    -- right click toggles main menu (nonexistant rn)
    -- awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ key bindings
globalkeys = gears.table.join(
    
    -- launch web browser
    awful.key({ modkey }, "b", function () awful.util.spawn(browser) end, {description = "open browser", group = "personal"}),


    -- minesweeper (just run the script by hand you lazy buffoon)
    awful.key({ modkey, "Mod1" }, "m", function () awful.util.spawn(screen:count() > 1 and "/home/will/UserApps/arbiter/start_minesweeper.sh" or "/home/will/UserApps/arbiter/start_minesweeper_single.sh") end, {description = "enter minesweeper mode", group = "personal"}),
    
    -- Spotify
    awful.key({ modkey, "Shift" }, "#83", function () awful.util.spawn("playerctl -p spotify previous") end, {description = "play previous spotify song", group = "media"}),
    awful.key({ modkey, "Shift" }, "#84", function () awful.util.spawn("playerctl -p spotify play-pause") end, {description = "play/pause spotify song", group = "media"}),
    awful.key({ modkey, "Shift" }, "#85", function () awful.util.spawn("playerctl -p spotify next") end, {description = "play next spotify song", group = "media"}),
    awful.key({ modkey, "Shift" }, "#80", function () awful.util.spawn("playerctl -p spotify volume 0.1+") end, {description = "lower spotify volume", group = "media"}),
    awful.key({ modkey, "Shift" }, "#88", function () awful.util.spawn("playerctl -p spotify volume 0.1-") end, {description = "raise spotify volume", group = "media"}),

    -- brightness
    awful.key({}, "XF86MonBrightnessUp", function () awful.util.spawn("sudo brillo -u 150000 -A 5") end, {description = 'brightness up', group = 'screen'}),
    awful.key({}, "XF86MonBrightnessDown", function () awful.util.spawn("sudo brillo -u 150000 -U 5") end, {description = 'brightness down', group = 'screen'}),

    -- volume
    awful.key({}, "XF86AudioRaiseVolume", function () volume_widget:inc(5) end, {description = 'volume down', group = 'media'}),
    awful.key({}, "XF86AudioLowerVolume", function () volume_widget:dec(5) end, {description = 'volume up', group = 'media'}),
    awful.key({}, "XF86AudioMute", function () volume_widget:toggle() end, {description = 'toggle mute', group = 'media'}),

    awful.key({ modkey, }, "Home", function () awful.util.spawn(gears.filesystem.get_configuration_dir() .. "i3lock-config.sh") end, {description = "lock screen", group = "client"}),

    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "h",
    function ()
        awful.client.focus.byidx( 1)
    end,
    {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "t",
    function ()
        awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
    ),

    awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.byidx(  1)    end,
    {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "t", function () awful.client.swap.byidx( -1)    end,
    {description = "swap with previous client by index", group = "client"}),
    
    -- Screen keybinds
    awful.key({ modkey, "Control" }, "h", function () awful.screen.focus_relative( 1) end,
    {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "t", function () awful.screen.focus_relative(-1) end,
    {description = "focus the previous screen", group = "screen"}),


    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
    function ()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end,
    {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
    {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
    {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "n",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "d",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "d",     function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "n",     function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "d",     function () awful.tag.incncol( 1, nil, true)    end,
    {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "n",     function () awful.tag.incncol(-1, nil, true)    end,
    {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "l",
    function ()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal(
            "request::activate", "key.unminimize", {raise = true}
            )
        end
    end,
    {description = "restore minimized", group = "client"}),

    -- Rofi
    awful.key({ modkey },            "r",     function ()
        awful.util.spawn("rofi -modes combi,run -show run -config " .. awesome_config_dir .. "rofi_conf.rasi") end,
        {description = "run rofi", group = "launcher"}),

    -- Run lua code
    awful.key({ modkey }, "x",
    function ()
        awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
              }
          end,
          {description = "lua execute prompt", group = "awesome"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "k",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "h",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags, skipping the middle 2 (5 and 6).
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1-4 and 7-0.
for i, v in ipairs({1,2,3,4,[5]=7,[6]=8,[7]=9,[8]=10}) do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. v + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = tags[i]
                        if tag then
                           -- Non-shared tags
                           -- tag:view_only()
                           sharedtags.viewonly(tag, screen)
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. v + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = tags[i]
                      if tag then
                         -- Non-shared tags
                         -- awful.tag.viewtoggle(tag)
                         sharedtags.viewtoggle(tag, screen)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. v + 9,
                  function ()
                      if client.focus then
                          -- Non-shared tags
                          -- local tag = client.focus.screen.tags[i]
                          local tag = tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. v + 9,
                  function ()
                      if client.focus then
                          -- Non-shared tags
                          -- local tag = client.focus.screen.tags[i]
                          local tag = tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- Use to keep track of programs which have been autostarted
autostarted = {}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
    properties = { border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = awful.client.focus.filter,
    raise = true,
    keys = clientkeys,
    buttons = clientbuttons,
    screen = awful.screen.preferred,
    placement = awful.placement.no_overlap+awful.placement.no_offscreen
        }
    },

    { rule = {class = "obsidian"},
        properties = { }, callback = function (c)
            if not autostarted.obsidian then
                -- NOTES tag
                awful.client.movetotag(tags[5], c)
                autostarted.obsidian = true
            end
        end
    },

    { rule = {class = "keepassxc"},
        properties = { }, callback = function (c)
            if not autostarted.keepassxc then
                -- MISC tag
                awful.client.movetotag(tags[6], c)
                autostarted.keepassxc = true
            end
        end
    },

    { rule = {class = "discord"},
        properties = { }, callback = function (c)
            if not autostarted.discord then
                -- MEDIA tag
                awful.client.movetotag(tags[7], c)
                autostarted.discord = true
            end
        end
    },

    { rule = {class = "spotify"},
        properties = { }, callback = function (c)
            if not autostarted.spotify then
                -- MUSIC tag
                awful.client.movetotag(tags[8], c)
                autostarted.spotify = true
            end
        end
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA",  -- Firefox addon DownThemAll.
            "copyq",  -- Includes session name in class.
            "pinentry",
        },
        class = {
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin",  -- kalarm.
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            "Wpa_gui",
            "veromix",
            "xtightvncviewer"},

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                "Event Tester",  -- xev.
            },
            role = {
                "AlarmWindow",  -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            }
        }, properties = { floating = true }},

        ---[[ Remove titlebars from normal clients and dialogs
        { rule_any = {type = { "normal", "dialog" }
    }, properties = { titlebars_enabled = false }
},
--]]
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    -- Titlebars iff layout is floating
    if c.floating and not (c.maximized or c.maximized_vertical or c.maximized_horizontal)then
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
    awful.button({ }, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
    end)
    )

    awful.titlebar(c) : setup {
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
    for k,c in pairs(clients) do
        if ((c.floating or c.first_tag.layout.name == "floating") and not (c.maximized or c.maximized_vertical or c.maximized_horizontal))  then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
end)

client.connect_signal("tagged", function(c,new_tag)
    -- if this page is alone on the new tag, maximize it
    if (#(new_tag:clients())==1) then
        c.maximized = true
        c.border_color = beautiful.border_normal
        awful.titlebar.hide(c)

    -- if it is not, unmaximize everything on that tag
    else
        for k,v in ipairs(new_tag:clients()) do
            v.maximized = false
        end
    end
end)

client.connect_signal("untagged", function(c,old_tag)
    -- if there is now only 1 page left
    if (#(old_tag:clients())==1) then
        for k,v in pairs(old_tag:clients()) do
            v.maximized = true
            v.border_color = beautiful.border_normal
            awful.titlebar.hide(v)
        end
    end
end)

-- only change focus border if the window is not fully maximized
-- only have a border if focused
client.connect_signal("focus", function(c) 
    if (c.maximized) then
        c.border_width = 0
        c.border_color = beautiful.border_normal
    else
        c.border_width = 2
        c.border_color = beautiful.border_focus
    end
end)

client.connect_signal("unfocus", function(c) 
    c.border_color = beautiful.border_normal
    c.border_width = 0
end)
-- }}}

naughty.config.defaults['icon_size'] = 100

-- autostart; toggle off for frequent reloads
awful.util.spawn_with_shell("~/.config/awesome/autostart.sh")
