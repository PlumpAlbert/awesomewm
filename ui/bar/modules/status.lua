-- Status
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local helpers = require("helpers")

local wifi = wibox.widget({
	font = beautiful.icofont .. " 12",
	markup = "󰤨",
	widget = wibox.widget.textbox,
	valign = "center",
	align = "center",
	buttons = {
		awful.button({}, 1, function()
			awesome.emit_signal("toggle::dashboard")
		end),
	},
})

local timer = wibox.widget({
	widget = wibox.container.arcchart,
	max_value = 100,
	min_value = 0,
	value = 69,
	thickness = dpi(3),
	rounded_edge = true,
	bg = beautiful.ok .. "4D",
	colors = { beautiful.ok },
	start_angle = math.pi + math.pi / 2,
	forced_width = dpi(15),
	forced_height = dpi(15),
	buttons = {
		awful.button({}, 1, function()
			awful.spawn.easy_async_with_shell(
				'pomodoro status -f "%!r"',
				---@param stdout string
				function(stdout)
					if #stdout == 1 then
						awful.spawn.with_shell("pomodoro start 25")
						return
					end
					awful.spawn.with_shell("pomodoro cancel")
					awesome.emit_signal("signal::pomodoro_time", 100)
				end
			)
		end),
	},
})

local l = nil
if beautiful.barDir == "left" or beautiful.barDir == "right" then
	l = wibox.layout.fixed.vertical
	wifi.font = beautiful.icofont .. " 12"
else
	l = wibox.layout.fixed.horizontal
	wifi.font = beautiful.icofont .. " 14"
end
local status = wibox.widget({
	{
		{
			{
				timer,
				wifi,
				layout = l,
				spacing = dpi(15),
			},
			margins = { top = dpi(10), bottom = dpi(10), left = dpi(6), right = dpi(6) },
			widget = wibox.container.margin,
		},
		layout = wibox.layout.stack,
	},
	widget = wibox.container.background,
	shape = helpers.rrect(2),
	bg = beautiful.bg2 .. "cc",
})

awesome.connect_signal("signal::network", function(value)
	if value then
		wifi.markup = helpers.colorizeText("󰤨", beautiful.fg)
	else
		wifi.markup = helpers.colorizeText("󰤮", beautiful.fg .. "99")
	end
end)

awesome.connect_signal("signal::pomodoro_time", function(value)
	timer.value = value
end)

return status
