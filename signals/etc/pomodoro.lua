local awful = require("awful")
local gears = require("gears")

-- Pomodoro Fetching and Signal Emitting
-- # Time
-- %r  - Time remaining in mm:ss
-- %R  - Time remaining in minutes, rounded
-- %!r - Same as %r, but with an exclamation point if the Pomodoro is done
-- %!R - Same as %R, but with an exclamation point if the Pomodoro is done
-- %l  - Length of the Pomodoro in mm:ss
-- %L  - Length of the Pomodoro in minutes
--
-- # Metadata
-- %d  - Pomodoro description
-- %t  - Pomodoro tags, joined by a comma
--
-- # Goals
-- %g  - Daily Pomodoro goal
-- %!g  - Daily Pomodoro goal, with a preceding slash
-- %c  - Completed Pomodoros today
-- %l  - Pomodoros remaining (left) to reach goal
local pomodoro_script = "pomodoro status -f '%!r~%l~%c'"

---@param s string
---@return number
local function get_time(s)
	local data = {}
	for t in s:gmatch("([^:]+)") do
		data[#data + 1] = t
	end
	local sum = 0
	for i = 1, #data do
		sum = sum + (data[#data + 1 - i] * (60 ^ (i - 1)))
	end
	return sum
end

local function pomodoro_emit()
	awful.spawn.easy_async_with_shell(
		pomodoro_script,
		---@param stdout string
		function(stdout)
			if #stdout == 1 then
				awesome.emit_signal("signal::pomodoro_stop")
				awesome.emit_signal("signal::pomodoro_time", 100)
                return
			end
			local meta = {}
			for data in string.gmatch(stdout, "([^~]+)") do
				meta[#meta + 1] = data
			end
			if meta[1] == "❗️" then
				awful.spawn.with_shell("pomodoro finish")
				awesome.emit_signal("signal::pomodoro_stop")
				return
			end
			local time_left = get_time(meta[1])
			local pomodoro_time = get_time(meta[2])
			awesome.emit_signal("signal::pomodoro_time", math.ceil(time_left / pomodoro_time * 100))
		end
	)
end

gears.timer({
	timeout = 1,
	call_now = true,
	autostart = true,
	callback = pomodoro_emit,
})
