local wezterm = require("wezterm")
local act = wezterm.action  -- Use shorthand for actions
local config = wezterm.config_builder()

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'MODE: ' .. name
  end
  window:set_right_status(name or '')
end)

config.initial_cols = 120
config.initial_rows = 28
config.font_size = 13
config.font = wezterm.font("ComicCodeLigatures Nerd Font")
config.color_scheme = "Kanagawa (Gogh)"
config.colors = {
	tab_bar = {
		background = "#1F1F28",
		active_tab = {
			bg_color = "#363646",
			fg_color = "#DCD7BA",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#1F1F28",
			fg_color = "#727169",
		},
	},
}
config.window_background_opacity = 0.9
config.wsl_domains = {
  {
    name = 'WSL:archlinux',
    distribution = 'archlinux',
    default_prog = { "fish" },
    default_cwd = "~/"
  },
}
config.default_domain = 'WSL:archlinux'
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }

-- Define key bindings
config.keys = {
	-- Tab mode activation
	{
		key = "t",
		mods = "LEADER",
		action = act.ActivateKeyTable {
			name = "tab_management",
			one_shot = false,
			timeout_milliseconds = 1000,  -- Auto-exit after 1 second of inactivity
		},
	},
	
	-- Pane mode activation
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateKeyTable {
			name = "pane_management",
			one_shot = false,
			timeout_milliseconds = 1000,  -- Auto-exit after 1 second of inactivity
		},
	},
	
	-- Fullscreen toggle
	{
		key = "f",
		mods = "LEADER",
		action = act.ToggleFullScreen,
	},
}

-- Define key tables
config.key_tables = {
	-- Tab management key table
	tab_management = {
		-- Create new tab - one_shot to exit after creating tab
		{ key = "n", action = act.Multiple({ act.SpawnTab("DefaultDomain"), act.PopKeyTable }) },
		
		-- Rename tab - exit mode immediately after pressing 'r'
		{ key = "r", action = act.Multiple({
			act.PromptInputLine({
				description = "Enter new tab name:",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
			act.PopKeyTable,
		})},
		
		-- Close tab - one_shot to exit after closing tab
		{ key = "x", action = act.Multiple({ act.CloseCurrentTab({ confirm = false }), act.PopKeyTable }) },
		
		-- Tab navigation
		{ key = "h", action = act.ActivateTabRelative(-1) },
		{ key = "l", action = act.ActivateTabRelative(1) },
		{ key = "LeftArrow", action = act.ActivateTabRelative(-1) },
		{ key = "RightArrow", action = act.ActivateTabRelative(1) },
		
		-- Exit tab management mode
		{ key = "Escape", action = act.PopKeyTable },
		{ key = "q", action = act.PopKeyTable },
	},
	
	-- Pane management key table
	pane_management = {
		-- Pane navigation with lowercase keys
		{ key = "h", action = act.ActivatePaneDirection("Left") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },
		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		
		-- Split panes with uppercase keys - one_shot to exit after creating pane
		{ key = "H", action = act.Multiple({ act.SplitPane({ direction = "Left" }), act.PopKeyTable }) },
		{ key = "J", action = act.Multiple({ act.SplitPane({ direction = "Down" }), act.PopKeyTable }) },
		{ key = "K", action = act.Multiple({ act.SplitPane({ direction = "Up" }), act.PopKeyTable }) },
		{ key = "L", action = act.Multiple({ act.SplitPane({ direction = "Right" }), act.PopKeyTable }) },
		
		-- Resize panes with Shift+Alt+letter
		{ key = "H", mods = "ALT", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "J", mods = "ALT", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "K", mods = "ALT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "L", mods = "ALT", action = act.AdjustPaneSize({ "Right", 5 }) },
		
		-- Close current pane - one_shot to exit after closing pane
		{ key = "x", action = act.Multiple({ act.CloseCurrentPane({ confirm = false }), act.PopKeyTable }) },
		
		-- Exit pane management mode
		{ key = "Escape", action = act.PopKeyTable },
		{ key = "q", action = act.PopKeyTable },
	},
}

return config
