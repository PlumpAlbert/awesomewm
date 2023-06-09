local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local menubar = require("menubar")
local apps = require("config.apps")
local mod = require("bindings.mod")
local widgets = require("misc.menus")
--local scratches = require 'misc.bling'.scratchpads
menubar.utils.terminal = apps.terminal

-- general awesome keys
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "space",
		description = "open application launcher",
		group = "awesome",
		on_press = function()
			awful.spawn("rofi -show combi")
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "F1",
		description = "show help",
		group = "awesome",
		on_press = hotkeys_popup.show_help,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "F5",
		description = "toggle day/night",
		group = "awesome",
		on_press = function()
			awful.spawn.with_shell("darkman toggle")
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "w",
		description = "show main menu",
		group = "awesome",
		on_press = function()
			widgets.mainmenu:show()
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "r",
		description = "reload awesome",
		group = "awesome",
		on_press = awesome.restart,
	}),
	--#region Screenshot
	awful.key({
		modifiers = {},
		key = "Print",
		description = "Screenshot",
		group = "awesome",
		on_press = function()
			awful.spawn("screenshot -d")
		end,
	}),
	awful.key({
		modifiers = { mod.shift },
		key = "Print",
		description = "Screenshot selection",
		group = "screenshot",
		on_press = function()
			awful.spawn("screenshot -s")
		end,
	}),
	awful.key({
		modifiers = { mod.alt },
		key = "Print",
		description = "Screenshot current window",
		group = "screenshot",
		on_press = function()
			awful.spawn("screenshot -w")
		end,
	}),
	--#endregion
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "q",
		description = "powermenu",
		group = "awesome",
		on_press = function()
			awesome.emit_signal("toggle::exit")
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "Return",
		description = "open a terminal",
		group = "launcher",
		on_press = function()
			awful.spawn(apps.terminal)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "r",
		description = "run prompt",
		group = "launcher",
		on_press = function()
			require("naughty").notify({ message = "hello" })
			awful.screen.focused().promptbox:run()
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "a",
		description = "show the menubar",
		group = "launcher",
		on_press = function()
			awesome.emit_signal("toggle::app_launcher")
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "v",
		description = "scratchpad",
		group = "scratches",
		on_press = function()
			awesome.emit_signal("toggle::pfetchpad")
		end,
	}),
})

-- tags related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "Left",
		description = "view preivous",
		group = "tag",
		on_press = awful.tag.viewprev,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "Right",
		description = "view next",
		group = "tag",
		on_press = awful.tag.viewnext,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "Escape",
		description = "go back",
		group = "tag",
		on_press = awful.tag.history.restore,
	}),
})

-- focus related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "j",
		description = "focus next by index",
		group = "client",
		on_press = function()
			awful.client.focus.byidx(1)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "k",
		description = "focus previous by index",
		group = "client",
		on_press = function()
			awful.client.focus.byidx(-1)
		end,
	}),
	-- awful.key({
	-- 	modifiers = { mod.super },
	-- 	key = "Tab",
	-- 	description = "go back",
	-- 	group = "client",
	-- 	on_press = function()
	-- 		awful.client.focus.history.previous()
	-- 		if client.focus then
	-- 			client.focus:raise()
	-- 		end
	-- 	end,
	-- }),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "j",
		description = "focus the next screen",
		group = "screen",
		on_press = function()
			awful.screen.focus_relative(1)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "n",
		description = "restore minimized",
		group = "client",
		on_press = function()
			local c = awful.client.restore()
			if c then
				c:active({ raise = true, context = "key.unminimize" })
			end
		end,
	}),
})

-- layout related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "j",
		description = "swap with next client by index",
		group = "client",
		on_press = function()
			awful.client.swap.byidx(1)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "k",
		description = "swap with previous client by index",
		group = "client",
		on_press = function()
			awful.client.swap.byidx(-1)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "u",
		description = "jump to urgent client",
		group = "client",
		on_press = awful.client.urgent.jumpto,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "l",
		description = "increase master width factor",
		group = "layout",
		on_press = function()
			awful.tag.incmwfact(0.05)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "h",
		description = "decrease master width factor",
		group = "layout",
		on_press = function()
			awful.tag.incmwfact(-0.05)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "h",
		description = "increase the number of master clients",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "l",
		description = "decrease the number of master clients",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(-1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "h",
		description = "increase the number of columns",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "l",
		description = "decrease the number of columns",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(-1, nil, true)
		end,
	}),
	awful.key({
		modifiers = { mod.alt },
		key = "space",
		description = "select next",
		group = "layout",
		on_press = function()
			awful.layout.inc(1)
		end,
	}),
	awful.key({
		modifiers = { mod.alt, mod.shift },
		key = "space",
		description = "select previous",
		group = "layout",
		on_press = function()
			awful.layout.inc(-1)
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "Tab",
		description = "window switcher",
		group = "bling",
		on_press = function()
			require("naughty").notify({ message = "ere" })
			awesome.emit_signal("bling::window_switcher::turn_on")
		end,
	}),
})

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		keygroup = "numrow",
		description = "only view tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl },
		keygroup = "numrow",
		description = "toggle tag",
		group = "tag",
		on_press = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:viewtoggle(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		keygroup = "numrow",
		description = "move focused client to tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.ctrl, mod.shift },
		keygroup = "numrow",
		description = "toggle focused client on tag",
		group = "tag",
		on_press = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		keygroup = "numpad",
		description = "select layout directrly",
		group = "layout",
		on_press = function(index)
			local tag = awful.screen.focused().selected_tag
			if tag then
				tag.layout = tag.layouts[index] or tag.layout
			end
		end,
	}),
})
