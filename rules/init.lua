local awful = require("awful")
local ruled = require("ruled")

ruled.client.connect_signal("request::rules", function()
	-- All clients will match this rule.
	ruled.client.append_rule({
		rule_any = {
			floating = true,
		},
		properties = {
			placement = awful.placement.centered,
		},
	})
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.centered + awful.placement.no_offscreen,
		},
	})

	-- Floating clients.
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = { "copyq", "pinentry" },
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"Sxiv",
				"Nsxiv",
				"Wpa_gui",
				"Nm-connection-editor",
				"veromix",
				"ncmpcpppad",
				"xtightvncviewer",
				"RescueTime",
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	})

	-- Add titlebars to normal clients and dialogs
	ruled.client.append_rule({
		id = "titlebars",
		rule_any = {
			type = { "dialog", "splash", "modal" },
		},
		properties = { titlebars_enabled = true },
	})

	ruled.client.append_rule({
		rule = { class = "Spotify" },
		properties = { screen = 2, tag = "1" },
	})

	ruled.client.append_rule({
		rule = { role = "pop-up" },
		properties = { screen = 2, tag = "2" },
	})
end)
