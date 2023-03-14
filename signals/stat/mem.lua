local awful = require("awful")
local gears = require("gears")
local function emit_mem_status()
	awful.spawn.easy_async_with_shell(
		"bash -c \"free | grep Mem | awk '{print $3/$2 * 100.0}'\"",
		---@param stdout string
		function(stdout)
			local usage = tonumber(stdout)
			awesome.emit_signal("signal::memory", math.ceil(usage or 0))
		end
	)
end

gears.timer({
	timeout = 60,
	call_now = true,
	autostart = true,
	callback = function()
		emit_mem_status()
	end,
})
