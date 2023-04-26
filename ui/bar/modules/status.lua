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
	buttons = {
		awful.button({}, 1, function()
			awesome.emit_signal("toggle::dashboard")
		end),
	},
})

awesome.connect_signal("signal::network", function(value)
	if value then
		wifi.markup = helpers.colorizeText("󰤨", beautiful.fg)
	else
		wifi.markup = helpers.colorizeText("󰤮", beautiful.fg .. "99")
	end
end)

return status
