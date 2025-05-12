local wezterm = require("wezterm")
local config = wezterm.config_builder()
config.initial_cols = 120
config.initial_rows = 28
config.default_prog = { "nu" }
config.font_size = 10
config.font = wezterm.font("JetBrains Mono Nerd Font")
config.color_scheme = "Kanagawa (Gogh)"
config.colors = {
	tab_bar = {
		background = "#1F1F28", -- Kanagawa sumiInk1 (dark background)
		active_tab = {
			bg_color = "#363646", -- Kanagawa fujiGray (slightly lighter)
			fg_color = "#DCD7BA", -- Kanagawa fujiWhite (off-white color)
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#1F1F28", -- Same as tab bar background
			fg_color = "#727169", -- Kanagawa fujiGray (muted)
		},
	},
}
config.window_background_opacity = 0.95

-- Set up leader key for tabs
local tab_leader = { key = "t", mods = "CTRL", timeout_milliseconds = 1000 }
config.leader = tab_leader

-- Add key bindings
config.keys = {
	-- Tab operations with Ctrl+T as leader
	{
		key = "n",
		mods = "LEADER",
		action = wezterm.action.SpawnTab("DefaultDomain"),
	},
	{
		key = "x",
		mods = "LEADER",
		action = wezterm.action.CloseCurrentTab({ confirm = false }),
	},
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

	-- Tab navigation
	{
		key = "h",
		mods = "CTRL",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "l",
		mods = "CTRL",
		action = wezterm.action.ActivateTabRelative(1),
	},

	-- Activate pane mode with Ctrl+P
	{
		key = "p",
		mods = "CTRL",
		action = wezterm.action.ActivateKeyTable({
			name = "pane_mode",
			one_shot = false,
			timeout_milliseconds = 1000,
			replace_current = false,
		}),
	},

	-- Pane navigation using Ctrl+Shift+HJKL (vim-style)
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
}

-- Define key table for pane operations
config.key_tables = {
	pane_mode = {
		-- 'l' creates a pane to the right
		{ key = "l", action = wezterm.action.SplitPane({ direction = "Right" }) },
		-- 'j' creates a pane below
		{ key = "j", action = wezterm.action.SplitPane({ direction = "Down" }) },
		-- 'x' closes the current pane
		{ key = "x", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
		-- Exit pane mode with Escape
		{ key = "Escape", action = wezterm.action.PopKeyTable },
	},
}

return config
