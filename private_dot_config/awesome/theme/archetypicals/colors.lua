local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require("gears")
local dpi = xresources.apply_dpi

local theme = {}

theme.dir = os.getenv("HOME") .. "/.config/awesome/theme/archetypicals"
theme.icon_dir = theme.dir .. "/icons"

-- Catppuccin Mocha coloring
theme.primary = "#FFFFFF"
theme.background = "#0E0412"
theme.surface = "#313244"
theme.rosewater = "#F5E0DC"
theme.flamingo = "#F2CDCD"
theme.pink = "#F5C2E7"
theme.mauve = "#CBA6F7"
theme.red = "#F38BA8"
theme.maroon = "#EBA0AC"
theme.peach = "#FAB387"
theme.yellow = "#F9E2AF"
theme.green = "#A6E3A1"
theme.teal = "#94E2D5"
theme.sky = "#89DCEB"
theme.sapphire = "#74C7EC"
theme.blue = "#89B4FA"
theme.lavender = "#B4BEFE"
theme.text = "#CDD6F4"
theme.subtext1 = "#BAC2DE"
theme.subtext0 = "#A6ADC8"
theme.overlay2 = "#9399B2"
theme.overlay1 = "#7F849C"
theme.overlay0 = "#6C7086"
theme.surface2 = "#585B70"
theme.surface1 = "#45475A"
theme.surface0 = "#313244"
theme.base = "#1E1E2E"
theme.mantle = "#181825"
theme.crust = "#11111B"

theme.wibar_element_transparency = "FF"

theme.menu_height = dpi(16)
theme.menu_width = dpi(140)
theme.menu_submenu_icon = theme.icon_dir .. "/submenu.png"
theme.widget_ac = theme.icon_dir .. "/ac.png"
theme.widget_battery = theme.icon_dir .. "/battery.png"
theme.widget_battery_low = theme.icon_dir .. "/battery_low.png"
theme.widget_battery_empty = theme.icon_dir .. "/battery_empty.png"
theme.widget_mem = theme.icon_dir .. "/mem.png"
theme.widget_cpu = theme.icon_dir .. "/cpu.png"
theme.widget_temp = theme.icon_dir .. "/temp.png"
theme.widget_net = theme.icon_dir .. "/net.png"
theme.widget_hdd = theme.icon_dir .. "/hdd.png"
theme.widget_music = theme.icon_dir .. "/note.png"
theme.widget_music_on = theme.icon_dir .. "/note_on.png"
theme.widget_vol = theme.icon_dir .. "/vol.png"
theme.widget_vol_low = theme.icon_dir .. "/vol_low.png"
theme.widget_vol_no = theme.icon_dir .. "/vol_no.png"
theme.widget_vol_mute = theme.icon_dir .. "/vol_mute.png"
theme.widget_mail = theme.icon_dir .. "/mail.png"
theme.widget_mail_on = theme.icon_dir .. "/mail_on.png"
theme.titlebar_close_button_focus = theme.icon_dir .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.icon_dir .. "/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active = theme.icon_dir .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.icon_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive = theme.icon_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.icon_dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active = theme.icon_dir .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.icon_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive = theme.icon_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.icon_dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active = theme.icon_dir .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.icon_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive = theme.icon_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = theme.icon_dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active = theme.icon_dir .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.icon_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive = theme.icon_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.icon_dir .. "/titlebar/maximized_normal_inactive.png"

theme.notification_bg = theme.surface1
theme.notification_fg = theme.overlay1

theme.fg_urgent = theme.red
theme.fg_minimize = theme.primary
theme.bg_urgent = theme.red

-- Default variables
theme.font = "Lexend"

theme.bg_normal = theme.background
theme.fg_normal = theme.primary
theme.bg_focus = theme.surface
theme.bg_systray = theme.background
theme.systray_icon_spacing = dpi(1)

-- border
theme.border_width = dpi(2)
theme.border_normal = theme.background
theme.border_focus = theme.lavender
theme.border_marked = theme.rose

theme.enable_spawn_cursor = true

theme.fullscreen_hide_border = true

-- Use the same old layout icons, but recolored
theme.layout_tile = theme.icon_dir .. "/tile.png"
theme.layout_tileleft = theme.icon_dir .. "/tileleft.png"
theme.layout_tilebottom = theme.icon_dir .. "/tilebottom.png"
theme.layout_tiletop = theme.icon_dir .. "/tiletop.png"
theme.layout_fairv = theme.icon_dir .. "/fairv.png"
theme.layout_fairh = theme.icon_dir .. "/fairh.png"
theme.layout_spiral = theme.icon_dir .. "/spiral.png"
theme.layout_dwindle = theme.icon_dir .. "/dwindle.png"
theme.layout_max = theme.icon_dir .. "/max.png"
theme.layout_fullscreen = theme.icon_dir .. "/fullscreen.png"
theme.layout_magnifier = theme.icon_dir .. "/magnifier.png"
theme.layout_floating = theme.icon_dir .. "/floating.png"

-- master
theme.master_width_factor = 0.60
theme.master_count = 1

-- maximized
theme.maximized_honor_padding = true
theme.maximized_hide_border = true

theme.taglist_shape = function(cr, width, height)
	return gears.shape.arc(cr, width, height, 3, 0, math.pi * 2)
end

theme.taglist_fg_urgent = theme.red .. theme.wibar_element_transparency
theme.taglist_bg_occupied = theme.primary .. theme.wibar_element_transparency
theme.taglist_bg_focus = theme.primary .. theme.wibar_element_transparency
theme.taglist_shape_focus = gears.shape.circle
theme.taglist_bg_empty = theme.surface1 .. theme.wibar_element_transparency
theme.taglist_disable_icon = true
theme.taglist_spacing = 8
theme.taglist_shape_border_width = 0
theme.taglist_font = 0

-- tasklist
theme.tasklist_fg_normal = theme.subtext1
theme.tasklist_bg_normal = theme.background
theme.tasklist_fg_focus = theme.primary
theme.tasklist_bg_focus = theme.surface2
theme.tasklist_align = "center"
theme.tasklist_plain_task_name = true
theme.tasklist_disable_icon = true

-- titlebar
theme.titlebar_bg_focus = theme.overlay2
theme.titlebar_bg_normal = theme.surface2
theme.titlebar_fg_focus = theme.overlay2

theme.wibar_height = 60

-- Stolen from other theme, you don't know what this is
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

return theme
