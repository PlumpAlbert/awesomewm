local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

local f = assert(io.popen("readlink -f /sbin/init", "r"))
---@type string
local output = f:read("*a")
f:close()

---@type 'systemd'|'openrc'|'runit'
local init_system = "systemd"
if output:match("openrc") then
	init_system = "openrc"
elseif output:match("runit") then
	init_system = "runit"
end

local powerofficon = "󰐥"
local rebooticon = "󰦛"
local suspendicon = "󰤄"
local exiticon = "󰈆"
local lockicon = "󰍁"

local poweroffcommand = function()
	if init_system == "openrc" then
		awful.spawn.with_shell("sudo -A openrc-shutdown -p 0")
	else
		awful.spawn.with_shell("sudo -A poweroff")
	end
	awesome.emit_signal("hide::exit")
end

local rebootcommand = function()
	if init_system == "openrc" then
		awful.spawn.with_shell("sudo -A openrc-shutdown -r 0")
	else
		awful.spawn.with_shell("sudo -A reboot")
	end
	awesome.emit_signal("hide::exit")
end

local suspendcommand = function()
	awesome.emit_signal("hide::exit")
	if init_system == "systemd" then
		awful.spawn.with_shell("systemctl suspend")
	end
end

local exitcommand = function()
	awesome.quit()
end

local lockcommand = function()
	awesome.emit_signal("hide::exit")
	if init_system == "systemd" then
		awful.spawn.with_shell("loginctl lock-session")
	end
end

local close = wibox.widget({
	{
		align = "center",
		font = beautiful.icofont .. " 24",
		markup = helpers.colorizeText("󰅖", beautiful.err),
		widget = wibox.widget.textbox,
	},
	widget = wibox.container.place,
	halign = "left",
	buttons = {
		awful.button({}, 1, function()
			awesome.emit_signal("hide::exit")
		end),
	},
})

local createButton = function(icon, cmd, color)
	local button = wibox.widget({
		{
			{
				id = "text_role",
				align = "center",
				font = beautiful.icofont .. " 45",
				markup = helpers.colorizeText(icon, color),
				widget = wibox.widget.textbox,
			},
			margins = 70,
			widget = wibox.container.margin,
		},
		border_color = color,
		border_width = dpi(5),
		bg = beautiful.bg,
		buttons = {
			awful.button({}, 1, function()
				cmd()
			end),
		},
		widget = wibox.container.background,
	})
	button:connect_signal("mouse::enter", function(self)
		self.bg = color
		self:get_children_by_id("text_role")[1].markup = helpers.colorizeText(icon, beautiful.bg)
	end)
	button:connect_signal("mouse::leave", function(self)
		self.bg = beautiful.bg
		self:get_children_by_id("text_role")[1].markup = helpers.colorizeText(icon, color)
	end)
	return button
end

local poweroffbutton = createButton(powerofficon, poweroffcommand, beautiful.err)
local rebootbutton = createButton(rebooticon, rebootcommand, beautiful.pri)
local lockbutton = createButton(lockicon, lockcommand, beautiful.dis)
local suspendbutton = createButton(suspendicon, suspendcommand, beautiful.warn)
local exitbutton = createButton(exiticon, exitcommand, beautiful.ok)

local box = wibox.widget({
	{
		{
			poweroffbutton,
			rebootbutton,
			lockbutton,
			suspendbutton,
			exitbutton,
			layout = wibox.layout.fixed.horizontal,
			spacing = 40,
		},
		spacing = 20,
		layout = wibox.layout.fixed.vertical,
	},
	widget = wibox.container.place,
	halign = "center",
})
local exit_screen_grabber = awful.keygrabber({
	auto_start = true,
	stop_event = "release",
	keypressed_callback = function(self, mod, key, command)
		if key == "s" then
			suspendcommand()
		elseif key == "e" then
			exitcommand()
		elseif key == "l" then
			lockcommand()
		elseif key == "p" then
			poweroffcommand()
		elseif key == "r" then
			rebootcommand()
		elseif key == "Escape" or key == "q" or key == "x" then
			awesome.emit_signal("hide::exit")
		end
	end,
})

awful.screen.connect_for_each_screen(function(s)
	local exit = wibox({
		type = "dock",
		shape = helpers.rrect(0),
		screen = s,
		width = beautiful.scrwidth,
		height = beautiful.scrheight,
		bg = beautiful.bg .. "44",
		ontop = true,
		visible = false,
	})
	exit:setup({
		{
			close,
			box,
			nil,
			expand = "none",
			layout = wibox.layout.align.vertical,
		},
		margins = dpi(15),
		widget = wibox.container.margin,
	})
	awful.placement.centered(exit, { honor_workarea = true })
	awesome.connect_signal("toggle::exit", function()
		if exit.visible then
			exit_screen_grabber:stop()
			exit.visible = false
		else
			exit.visible = true
			exit_screen_grabber:start()
		end
	end)
	awesome.connect_signal("show::exit", function()
		exit_screen_grabber:start()
		exit.visible = true
	end)
	awesome.connect_signal("hide::exit", function()
		exit_screen_grabber:stop()
		exit.visible = false
	end)
end)
