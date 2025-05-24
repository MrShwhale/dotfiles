local theme_assets                              = require("beautiful.theme_assets")
local xresources                                = require("beautiful.xresources")
local dpi                                       = xresources.apply_dpi
local gears                                     = require("gears")

local theme                                     = {}

theme.dir                                       = os.getenv("HOME") .. "/.config/awesome"
theme.icon_dir                                  = theme.dir .. "/mizuki_darker_v2_icons"

theme.on_primary_container                      = "#1C1149"
theme.primary_container                         = "#E6DEFF"
theme.on_surface_variant                        = "#48454E"
theme.surface_variant                           = "#E6E0EC"
theme.on_tertiary_container                     = "#301120"
theme.tertiary_container                        = "#FFD8E6"
theme.error                                     = "#BA1A1A"
theme.primary                                   = "#605790"
theme.inverse_primary                           = "#C9BEFF"

theme.wibar_element_transparency                = "FF"

theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.icon_dir .. "/submenu.png"
theme.widget_ac                                 = theme.icon_dir .. "/ac.png"
theme.widget_battery                            = theme.icon_dir .. "/battery.png"
theme.widget_battery_low                        = theme.icon_dir .. "/battery_low.png"
theme.widget_battery_empty                      = theme.icon_dir .. "/battery_empty.png"
theme.widget_mem                                = theme.icon_dir .. "/mem.png"
theme.widget_cpu                                = theme.icon_dir .. "/cpu.png"
theme.widget_temp                               = theme.icon_dir .. "/temp.png"
theme.widget_net                                = theme.icon_dir .. "/net.png"
theme.widget_hdd                                = theme.icon_dir .. "/hdd.png"
theme.widget_music                              = theme.icon_dir .. "/note.png"
theme.widget_music_on                           = theme.icon_dir .. "/note_on.png"
theme.widget_vol                                = theme.icon_dir .. "/vol.png"
theme.widget_vol_low                            = theme.icon_dir .. "/vol_low.png"
theme.widget_vol_no                             = theme.icon_dir .. "/vol_no.png"
theme.widget_vol_mute                           = theme.icon_dir .. "/vol_mute.png"
theme.widget_mail                               = theme.icon_dir .. "/mail.png"
theme.widget_mail_on                            = theme.icon_dir .. "/mail_on.png"
theme.titlebar_close_button_focus               = theme.icon_dir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.icon_dir .. "/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.icon_dir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.icon_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.icon_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.icon_dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.icon_dir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.icon_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.icon_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.icon_dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.icon_dir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.icon_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.icon_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.icon_dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.icon_dir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.icon_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.icon_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.icon_dir .. "/titlebar/maximized_normal_inactive.png"

--{{{ Setting beautiful variables

theme.notification_bg                           = theme.surface_variant
theme.notification_fg                           = theme.on_surface_variant

theme.fg_urgent                                 = theme.error
theme.fg_minimize                               = "#ffffff"
theme.bg_urgent                                 = theme.error
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#7F7F7F"
theme.border_marked                             = "#CC9393"
theme.tasklist_bg_focus                         = "#1A1A1A"

-- Default variables
theme.font                                      = "Lexend"

theme.bg_normal                                 = theme.surface_variant
theme.fg_normal                                 = theme.on_surface_variant
theme.bg_focus                                  = "#e3e1ec"
theme.bg_systray                                = theme.bg
theme.systray_icon_spacing                      = dpi(1)

-- border
theme.border_width                              = dpi(2)
theme.border_normal                             = "#BDC3F9"
theme.border_focus                              = "#FDAAFF"
theme.border_marked                             = "#BBC3FF"

theme.enable_spawn_cursor                       = true

theme.fg_normal                                 = "#bbc3ff"
theme.fg_focus                                  = nil

theme.fullscreen_hide_border                    = true

-- Use the same old layout icons, but recolored
theme.layout_tile                               = theme.icon_dir .. "/tile.png"
theme.layout_tileleft                           = theme.icon_dir .. "/tileleft.png"
theme.layout_tilebottom                         = theme.icon_dir .. "/tilebottom.png"
theme.layout_tiletop                            = theme.icon_dir .. "/tiletop.png"
theme.layout_fairv                              = theme.icon_dir .. "/fairv.png"
theme.layout_fairh                              = theme.icon_dir .. "/fairh.png"
theme.layout_spiral                             = theme.icon_dir .. "/spiral.png"
theme.layout_dwindle                            = theme.icon_dir .. "/dwindle.png"
theme.layout_max                                = theme.icon_dir .. "/max.png"
theme.layout_fullscreen                         = theme.icon_dir .. "/fullscreen.png"
theme.layout_magnifier                          = theme.icon_dir .. "/magnifier.png"
theme.layout_floating                           = theme.icon_dir .. "/floating.png"

-- master
theme.master_width_factor                       = 0.60
theme.master_count                              = 1

-- maximized
theme.maximized_honor_padding                   = true
theme.maximized_hide_border                     = true

theme.taglist_shape                             = function(cr, width, height)
    return gears.shape.arc(cr, width, height, dpi(5), 0, math.pi * 2)
end

theme.taglist_fg_urgent                         = theme.error .. theme.wibar_element_transparency
theme.taglist_bg_occupied                       = theme.primary .. theme.wibar_element_transparency
theme.taglist_bg_focus                          = theme.primary .. theme.wibar_element_transparency
theme.taglist_shape_focus                       = gears.shape.circle
theme.taglist_bg_empty                          = theme.inverse_primary .. theme.wibar_element_transparency
theme.taglist_disable_icon                      = true
theme.taglist_spacing                           = dpi(10)
theme.taglist_shape_border_width                = 0
theme.taglist_font                              = 0

-- tasklist
theme.tasklist_fg_normal                        = theme.on_tertiary_container
theme.tasklist_bg_normal                        = theme.tertiary_container .. "99"
theme.tasklist_fg_focus                         = theme.on_primary_container
theme.tasklist_bg_focus                         = theme.primary_container
theme.tasklist_align                            = "center"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true

-- titlebar
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus

-- Gap between clients
theme.useless_gap                               = dpi(3)
theme.wibar_height                              = dpi(72)

-- Stolen from other theme, you don't know what this is
theme.awesome_icon                              = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- }}}

return theme
