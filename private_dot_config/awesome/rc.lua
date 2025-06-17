-- Thanks to https://github.com/eromatiya/the-glorious-dotfiles for the cool organization setup
pcall(require, "luarocks.loader")
-- TODO this is wrong, apparently
require("awful.autofocus")

-- TODO overhaul
require("module.setup")

-- TODO overhaul
require("module.global_keybinds")

-- TODO overhaul
require("module.client_keybinds")

-- TODO overhaul
-- DOUBLE overhaul, this is TERRIBLE
require("module.signals")

-- TODO totally change
require("module.wallpaper")

-- TODO add stuff
require("module.autostart")
