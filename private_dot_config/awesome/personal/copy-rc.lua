-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
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
beautiful.init("/home/will/.config/awesome/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

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
mykeyboardlayout = awful.widget.keyboardlayout()

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

    -- Each screen has its own tag table.
    awful.tag({ "PRIMARY", "SECONDARY", "TERTIARY", "DOCS", "NOTES", "MISC", "MEDIA", "MUSIC" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    --[[
    
        -- Textclock
        local clockicon = wibox.widget.imagebox(beautiful.widget_clock)
        local clock = awful.widget.watch(
            "date +'%a %d %b %R'", 60,
            function(widget, stdout)
                widget:set_markup(" " .. markup.font(beautiful.font, stdout))
            end
        )

        -- Calendar
        beautiful.cal = lain.widget.cal({
            attach_to = { clock },
            notification_preset = {
                font = "Terminus 10",
                fg   = beautiful.fg_normal,
                bg   = beautiful.bg_normal
            }
        })

        -- Mail IMAP check
        local mailicon = wibox.widget.imagebox(beautiful.widget_mail)
        --[[ commented because it needs to be set before use
        mailicon:buttons(my_table.join(awful.button({ }, 1, function () awful.spawn(mail) end)))
        beautiful.mail = lain.widget.imap({
            timeout  = 180,
            server   = "server",
            mail     = "mail",
            password = "keyring get mail",
            settings = function()
                if mailcount > 0 then
                    widget:set_markup(markup.font(beautiful.font, " " .. mailcount .. " "))
                    mailicon:set_image(beautiful.widget_mail_on)
                else
                    widget:set_text("")
                    mailicon:set_image(beautiful.widget_mail)
                end
            end
        })
        

        -- MPD
        local musicplr = awful.util.terminal .. " -title Music -e ncmpcpp"
        local mpdicon = wibox.widget.imagebox(beautiful.widget_music)
        mpdicon:buttons(my_table.join(
            awful.button({ "Mod4" }, 1, function () awful.spawn(musicplr) end),
            awful.button({ }, 1, function ()
                os.execute("mpc prev")
                beautiful.mpd.update()
            end),
            awful.button({ }, 2, function ()
                os.execute("mpc toggle")
                beautiful.mpd.update()
            end),
            awful.button({ }, 3, function ()
                os.execute("mpc next")
                beautiful.mpd.update()
            end)))
        beautiful.mpd = lain.widget.mpd({
            settings = function()
                if mpd_now.state == "play" then
                    artist = " " .. mpd_now.artist .. " "
                    title  = mpd_now.title  .. " "
                    mpdicon:set_image(beautiful.widget_music_on)
                elseif mpd_now.state == "pause" then
                    artist = " mpd "
                    title  = "paused "
                else
                    artist = ""
                    title  = ""
                    mpdicon:set_image(beautiful.widget_music)
                end

                widget:set_markup(markup.font(beautiful.font, markup("#EA6F81", artist) .. title))
            end
        })

        -- MEM
        local memicon = wibox.widget.imagebox(beautiful.widget_mem)
        local mem = lain.widget.mem({
            settings = function()
                widget:set_markup(markup.font(beautiful.font, " " .. mem_now.used .. "MB "))
            end
        })

        -- CPU
        local cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
        local cpu = lain.widget.cpu({
            settings = function()
                widget:set_markup(markup.font(beautiful.font, " " .. cpu_now.usage .. "% "))
            end
        })

        -- Coretemp
        local tempicon = wibox.widget.imagebox(beautiful.widget_temp)
        local temp = lain.widget.temp({
            settings = function()
                widget:set_markup(markup.font(beautiful.font, " " .. coretemp_now .. "°C "))
            end
        })

        -- / fs
        local fsicon = wibox.widget.imagebox(beautiful.widget_hdd)
        --[[ commented because it needs Gio/Glib >= 2.54
        beautiful.fs = lain.widget.fs({
            notification_preset = { fg = beautiful.fg_normal, bg = beautiful.bg_normal, font = "Terminus 10" },
            settings = function()
                widget:set_markup(markup.font(beautiful.font, " " .. fs_now["/"].percentage .. "% "))
            end
        })
        --]

        -- Battery
        local baticon = wibox.widget.imagebox(beautiful.widget_battery)
        local bat = lain.widget.bat({
            settings = function()
                if bat_now.status and bat_now.status ~= "N/A" then
                    if bat_now.ac_status == 1 then
                        baticon:set_image(beautiful.widget_ac)
                    elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                        baticon:set_image(beautiful.widget_battery_empty)
                    elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                        baticon:set_image(beautiful.widget_battery_low)
                    else
                        baticon:set_image(beautiful.widget_battery)
                    end
                    widget:set_markup(markup.font(beautiful.font, " " .. bat_now.perc .. "% "))
                else
                    widget:set_markup(markup.font(beautiful.font, " AC "))
                    baticon:set_image(beautiful.widget_ac)
                end
            end
        })

        -- ALSA volume
        local volicon = wibox.widget.imagebox(beautiful.widget_vol)
        beautiful.volume = lain.widget.alsa({
            settings = function()
                if volume_now.status == "off" then
                    volicon:set_image(beautiful.widget_vol_mute)
                elseif tonumber(volume_now.level) == 0 then
                    volicon:set_image(beautiful.widget_vol_no)
                elseif tonumber(volume_now.level) <= 50 then
                    volicon:set_image(beautiful.widget_vol_low)
                else
                    volicon:set_image(beautiful.widget_vol)
                end

                widget:set_markup(markup.font(beautiful.font, " " .. volume_now.level .. "% "))
            end
        })
        beautiful.volume.widget:buttons(awful.util.table.join(
                                       awful.button({}, 4, function ()
                                             awful.util.spawn("amixer set Master 1%+")
                                             beautiful.volume.update()
                                       end),
                                       awful.button({}, 5, function ()
                                             awful.util.spawn("amixer set Master 1%-")
                                             beautiful.volume.update()
                                       end)
        ))

        -- Net
        local neticon = wibox.widget.imagebox(beautiful.widget_net)
        local net = lain.widget.net({
            settings = function()
                widget:set_markup(markup.font(beautiful.font,
                                  markup("#7AC82E", " " .. string.format("%06.1f", net_now.received))
                                  .. " " ..
                                  markup("#46A8C3", " " .. string.format("%06.1f", net_now.sent) .. " ")))
            end
        })
    --]]

    s.mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.wibar_height })

    --local spr = beautiful.wibar_sepr
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --spr,
            s.mytaglist,
            s.mypromptbox,
            spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            ---[[
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,--]]
           --[[ 
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            keyboardlayout,
            spr,
            arrl_ld,
            wibox.container.background(mpdicon, theme.bg_focus),
            wibox.container.background(theme.mpd.widget, theme.bg_focus),
            arrl_dl,
            volicon,
            theme.volume.widget,
            arrl_ld,
            wibox.container.background(mailicon, theme.bg_focus),
            --wibox.container.background(theme.mail.widget, theme.bg_focus),
            arrl_dl,
            memicon,
            mem.widget,
            arrl_ld,
            wibox.container.background(cpuicon, theme.bg_focus),
            wibox.container.background(cpu.widget, theme.bg_focus),
            arrl_dl,
            tempicon,
            temp.widget,
            arrl_ld,
            wibox.container.background(fsicon, theme.bg_focus),
            --wibox.container.background(theme.fs.widget, theme.bg_focus),
            arrl_dl,
            baticon,
            bat.widget,
            arrl_ld,
            wibox.container.background(neticon, theme.bg_focus),
            wibox.container.background(net.widget, theme.bg_focus),
            arrl_dl,
            clock,
            spr,
            arrl_ld,
            wibox.container.background(s.mylayoutbox, theme.bg_focus),--]]
        },
    }
end)
-- }}} ]]


-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    
    -- Launch web browser
    awful.key({ modkey }, "b", function () awful.util.spawn("opera") end, {description = "open opera browser", group = "launcher"}),

    -- Spotify
    awful.key({ modkey, "Shift" }, "#83", function () awful.util.spawn("playerctl -p spotify previous") end, {description = "play previous Spotify song", group = "media"}),
    awful.key({ modkey, "Shift" }, "#84", function () awful.util.spawn("playerctl -p spotify play-pause") end, {description = "play/pause Spotify song", group = "media"}),
    awful.key({ modkey, "Shift" }, "#85", function () awful.util.spawn("playerctl -p spotify next") end, {description = "play next Spotify song", group = "media"}),
    awful.key({ modkey, "Shift" }, "#80", function () awful.util.spawn("playerctl -p spotify volume 0.1+") end, {description = "lower Spotify volume", group = "media"}),
    awful.key({ modkey, "Shift" }, "#88", function () awful.util.spawn("playerctl -p spotify volume 0.1-") end, {description = "Raise Spotify volume", group = "media"}),

    awful.key({ modkey, "Mod1"  }, "l", function () awful.util.spawn(gears.filesystem.get_configuration_dir() .. "i3lock-config.sh") end, {description = "lock screen", group = "client"}),

    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
    {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
    function ()
        awful.client.focus.byidx( 1)
    end,
    {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
    function ()
        awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
    ),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --          {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
    {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
    {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
    {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
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

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
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

    -- Dmenu
    awful.key({ modkey },            "r",     function () 
        awful.util.spawn("dmenu_run -fn NotoSansMono-" .. beautiful.dmenu_font_size) end, 
        {description = "run dmenu", group = "launcher"}),

        awful.key({ modkey }, "x",
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
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
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
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
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. v + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. v + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
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
                          local tag = client.focus.screen.tags[i]
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
      }, properties = { titlebars_enabled = true }
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
    if c.floating then
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
        if (c.floating or c.first_tag.layout.name == "floating")  then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- Spawns a program (based on identifier) on the tag with the specified name
function spawn(command, class, tag_name, test)
    local test = test or "class"
    local tag = awful.tag.find_by_name(awful.screen.focused(), tag_name)
    local callback
    callback = function(c)
        if test == "class" then
            if c.class == class then
                c:move_to_tag(tag)
                client.disconnect_signal("manage", callback)
            end
        elseif test == "instance" then
            if c.instance == class then
                c:move_to_tag(tag)
                client.disconnect_signal("manage", callback)
            end
        elseif test == "name" then
           if string.match(c.name, class) then
                c:move_to_tag(tag)
                client.disconnect_signal("manage", callback)
            end
        end
    end
    client.connect_signal("manage", callback)
    awful.util.spawn_with_shell(command)
end

-- Autostart; toggle off for frequent reloads
--[[
awful.spawn("~/.config/awesome/autostart.sh")
spawn("joplin-desktop", "Joplin", "NOTES", "class")
spawn("discord", "discord", "MEDIA", "class")
spawn("spotify", "Spotify", "MUSIC", "class")
--]]
