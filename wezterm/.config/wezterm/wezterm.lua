-- Pull in the wezterm API
local wezterm = require("wezterm")
-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 10
config.font = wezterm.font("JetBrains Mono Nerd Font")
config.color_scheme = "Kanagawa (Gogh)"

-- Set up leader key (Ctrl+T) with a timeout
config.leader = { key = "t", mods = "CTRL", timeout_milliseconds = 1000 }

-- Add key bindings
config.keys = {
	-- Ctrl+T followed by N creates a new tab
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("DefaultDomain"),
	},

	-- Ctrl+T followed by X closes the current tab
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},

	-- Ctrl+T followed by R renames the current tab
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new tab name:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Ctrl+H to go to left tab
	{
		key = "h",
		mods = "CTRL",
		action = wezterm.action.ActivateTabRelative(-1),
	},

	-- Ctrl+L to go to right tab
	{
		key = "l",
		mods = "CTRL",
		action = wezterm.action.ActivateTabRelative(1),
	},
}

-- Finally, return the configuration to wezterm:
return config
