local awful = require("awful")
local gears = require("gears")
local naughty = require"naughty"

local function volume_emit()
	awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_AUDIO_SOURCE@", function(value)
		local s = value:match("%[MUTED%]")
		awesome.emit_signal("signal::mic", s == "") -- integer
	end)
end

gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = function()
		volume_emit()
	end,
})
