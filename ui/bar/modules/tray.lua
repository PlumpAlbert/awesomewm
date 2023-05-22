-- THIS WAS ENTIRELY WRITTEN BY ME SO IT WILL CONTAIN UNREADABEL / WORST CODE EVER SEEN

local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local dpi = require("beautiful").xresources.apply_dpi

local is_vertical = beautiful.barDir == "left" or beautiful.barDir == "right"

-- TOGGLER

local togglertext = wibox.widget({
	font = beautiful.icofont .. " 20",
	text = "󰅀",
	valign = "center",
	align = "center",
	buttons = {
		awful.button({}, 1, function()
			awesome.emit_signal("systray::toggle")
		end),
	},
	widget = wibox.widget.textbox,
})

local l = nil
if is_vertical then
	l = wibox.layout.fixed.vertical
else
	l = wibox.layout.fixed.horizontal
end
-- TRAY

local tray = wibox.widget.systray(false)
tray:set_horizontal(not is_vertical)
local systray = wibox.widget({
	{
		widget = tray,
	},
	top = dpi(9),
	bottom = dpi(9),
	visible = true,
	left = dpi(9),
	right = dpi(9),
	widget = wibox.container.margin,
})

awesome.connect_signal("systray::toggle", function()
	if systray.visible then
		systray.visible = false
		if beautiful.barDir == "left" or beautiful.barDir == "right" then
			togglertext.text = "󰅃"
		else
			togglertext.text = "󰅁"
		end
	else
		systray.visible = true
		if beautiful.barDir == "left" or beautiful.barDir == "right" then
			togglertext.text = "󰅀"
		else
			togglertext.text = "󰅂"
		end
	end
end)

local widget = wibox.widget({
	{
		{
			systray,
			togglertext,
			layout = l,
		},
		shape = helpers.rrect(2),
		bg = beautiful.fg3,
		fg = beautiful.bg2,
		widget = wibox.container.background,
	},
	margins = 0,
	widget = wibox.container.margin,
})
return widget
