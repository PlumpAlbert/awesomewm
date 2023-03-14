local awful = require("awful")
local gears = require("gears")
local function emit_cpu_status()
	awful.spawn.easy_async_with_shell(
		"bash -c \"grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'\"",
		---@param stdout number
		function(stdout)
			local usage = tonumber(stdout)
			awesome.emit_signal("signal::cpu", math.ceil(usage or 0))
		end
	)
end

gears.timer({
	timeout = 60,
	call_now = true,
	autostart = true,
	callback = function()
		emit_cpu_status()
	end,
})
