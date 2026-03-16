local wezterm = require("wezterm")
local config = {}

config.default_prog = { "/usr/bin/fish" }
config.color_scheme = "nord"
config.font = wezterm.font("Hack")
config.font_size = 11
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
	{
		key = "Enter",
		mods = "ALT",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

return config
