local theme_assets                              = require("beautiful.theme_assets")
local xresources                                = require("beautiful.xresources")
local dpi                                       = xresources.apply_dpi
local gears                                     = require("gears")

local theme                                     = {}

theme.dir                                       = os.getenv("HOME") .. "/.config/awesome"

-- Wibar-like
theme.wibar_element_transparency                = "FF"

theme.fg_urgent                                 = "#BB9AF7"
theme.fg_minimize                               = "#ffffff"
theme.bg_urgent                                 = "#1A1A1A"
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#7F7F7F"
theme.border_marked                             = "#CC9393"
theme.tasklist_bg_focus                         = "#1A1A1A"
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(140)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                                = theme.dir .. "/icons/cpu.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note_on.png"
theme.widget_vol                                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

--{{{ Setting beautiful variables

-- Default variables
theme.font                                      = "Lexend"

theme.bg_normal                                 = "#12131a"
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

-- Use the same old layout icons
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"

-- master
theme.master_width_factor                       = 0.60
theme.master_count                              = 1

-- maximized
theme.maximized_honor_padding                   = true
theme.maximized_hide_border                     = true

-- Tertiary
theme.taglist_fg_focus                          = "#580064" .. theme.wibar_element_transparency
theme.taglist_bg_focus                          = "#fdaaff" .. theme.wibar_element_transparency

-- Error
theme.taglist_fg_urgent                         = "#690005" .. theme.wibar_element_transparency
theme.taglist_bg_urgent                         = "#ffb4ab" .. theme.wibar_element_transparency

-- Surface variant
theme.taglist_bg_occupied                       = "#454654" .. theme.wibar_element_transparency
theme.taglist_fg_occupied                       = "#c5c5d6" .. theme.wibar_element_transparency

-- Inverse surface
theme.taglist_bg_empty                          = "#e3e1ec" .. theme.wibar_element_transparency
theme.taglist_fg_empty                          = "#2f3038" .. theme.wibar_element_transparency

theme.taglist_disable_icon                      = true
theme.taglist_shape                             = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height,
        15)
end

-- TODO this is not exactly perfect spacing, invest in a layout
theme.taglist_spacing                           = dpi(4)
theme.taglist_shape_border_width                = dpi(1)
theme.taglist_font                              = "Lexend 12"
theme.taglist_shape_border_color                = "#0d0e15"

-- tasklist
-- TODO consider setting the globals for this
theme.tasklist_fg_normal                        = "#c5c5d6"
theme.tasklist_bg_normal                        = "#454654"
theme.tasklist_fg_focus                         = "#580064"
theme.tasklist_bg_focus                         = "#fdaaff"
theme.tasklist_align                            = "center"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true

-- titlebar
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus

-- Gap between clients
theme.useless_gap                               = dpi(3)

theme.wibar_height                              = dpi(70)

-- Stolen from other theme, you don't know what this is
theme.awesome_icon                              = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- }}}

return theme
