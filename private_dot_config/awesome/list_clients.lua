require("awful")
local naughty = require("naughty")
for _, c in ipairs(client.get()) do
    naughty.notify({text = c.name .. " " .. c.pid})
end
