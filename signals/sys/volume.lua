local awful = require("awful")
local gears = require("gears")

local function volume_emit()
	awful.spawn.easy_async_with_shell(
		"wpctl get-volume @DEFAULT_AUDIO_SINK@",
		---@param stdout string
		function(stdout)
			local s = stdout:match("Volume: (.*)")
			if not s then
				awesome.emit_signal("signal::volume", 0)
			end
			local volume_int = tonumber(s) * 100 -- integer
			awesome.emit_signal("signal::volume", volume_int) -- integer
		end
	)
end

-- Microphone Fetching and Signal Emitting
-- Refreshing
-------------
gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = function()
		volume_emit()
	end,
})
