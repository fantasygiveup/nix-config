local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.default_prog = { "zsh", "--login", "-c", " tmux attach -t '󱃖 dev' || tmux new -d -s ' media'; tmux new -d -s '󱗀 work'; tmux new -s '󱃖 dev'" }
config.initial_cols = 511
config.initial_rows = 511
config.audible_bell = "Disabled"
config.font = wezterm.font("JetBrainsMono Nerd Font Mono", { weight = "Bold" })
config.warn_about_missing_glyphs = false
config.use_fancy_tab_bar = false
config.freetype_load_target = "HorizontalLcd"
config.freetype_render_target = "HorizontalLcd"
config.window_decorations = "NONE"
config.cell_width = 0.9 -- font tracking
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.93 }

-- Catppuccin latte theme.
config.colors = {
  foreground = "@fg0@",
  background = "@bg0@",
  cursor_bg = "@fg0@",
  cursor_fg = "@bg0@",
  split = "@a7@",
  selection_bg = "@fg0@",
  selection_fg = "@bg0@",

  ansi = {
    "@a0@",
    "@a1@",
    "@a2@",
    "@a3@",
    "@a4@",
    "@a5@",
    "@a6@",
    "@a7@",
  },
  brights = {
    "@a8@",
    "@a9@",
    "@a10@",
    "@a11@",
    "@a12@",
    "@a13@",
    "@a14@",
    "@a15@",
  },
  tab_bar = {
    background = "@bg0@",
    -- Hide + button sign.
    new_tab = {
      fg_color = "@bg0@",
      bg_color = "@bg0@",
    },
    new_tab_hover = {
      fg_color = "@bg0@",
      bg_color = "@bg0@",
    },
  },
}

config.window_frame = {
  active_titlebar_bg = "@a0@",
  inactive_titlebar_bg = "@a0@",
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  return { { Text = ""} }
end)

config.font_size = 11;
wezterm.on("increase-font-size", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.font_size = (overrides.font_size or config.font_size) + 1.0
  window:set_config_overrides(overrides)
end)

wezterm.on("decrease-font-size", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.font_size = (overrides.font_size or config.font_size) - 1.0
  window:set_config_overrides(overrides)
end)

wezterm.on("reset-font-size", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.font_size = 11
  window:set_config_overrides(overrides)
end)

config.line_height = 1.0
wezterm.on("increase-leading", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.line_height = (overrides.line_height or config.line_height) + 0.4
  window:set_config_overrides(overrides)
end)

wezterm.on("decrease-leading", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.line_height = math.max((overrides.line_height or config.line_height) - 0.4, 1.0) -- Keep it reasonable
  window:set_config_overrides(overrides)
end)

wezterm.on("reset-leading", function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.line_height = 1.0
  window:set_config_overrides(overrides)
end)

-- Remove extra top padding.
wezterm.on("update-right-status", function(window, pane)
	local overrides = window:get_config_overrides() or {}
  overrides.window_padding = { top = '0cell' }
	window:set_config_overrides(overrides)
end)

wezterm.on("format-window-title", function ()
	return "wezterm"
end)

-- Let tmux handle everything.
config.disable_default_key_bindings = true
config.keys = {
  {
    key = "c",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CopyTo("Clipboard"),
  },
  {
    key = "v",
    mods = "CTRL|SHIFT",
    action = wezterm.action.PasteFrom("Clipboard"),
  },
  {
    key = "=",
    mods = "CTRL",
    action = wezterm.action.EmitEvent("increase-font-size"),
  },
  {
    key = "-",
    mods = "CTRL",
    action = wezterm.action.EmitEvent("decrease-font-size"),
  },
  {
    key = "0",
    mods = "CTRL",
    action = wezterm.action.EmitEvent("reset-font-size"),
  },
  {
    key = "+",
    mods = "CTRL|SHIFT",
    action = wezterm.action.EmitEvent("increase-leading"),
  },
  {
    key = "_",
    mods = "CTRL|SHIFT",
    action = wezterm.action.EmitEvent("decrease-leading"),
  },
  {
    key = ")",
    mods = "CTRL|SHIFT",
    action = wezterm.action.EmitEvent("reset-leading"),
  },
  {
    key = "F11",
    action = wezterm.action.ToggleFullScreen,
  },
}

return config
