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
  foreground = "#4c4f69",
  background = "#eff1f5",
  cursor_bg = "#4c4f69",
  cursor_fg = "#eff1f5",
  split = "#dce0e8",
  selection_bg = "#4c4f69",
  selection_fg = "#eff1f5",

  ansi = {
    "#bcc0cc",
    "#d20f39",
    "#40a02b",
    "#df8e1d",
    "#1e66f5",
    "#ea76cb",
    "#04a5e5",
    "#dce0e8",
  },
  brights = {
    "#bcc0cc",
    "#de0332",
    "#37ab20",
    "#ec8e10",
    "#1462ff",
    "#f26ecd",
    "#0090e9",
    "#434872",
  },
  tab_bar = {
    background = "#eff1f5",
    -- Hide + button sign.
    new_tab = {
      fg_color = "#eff1f5",
      bg_color = "#eff1f5",
    },
    new_tab_hover = {
      fg_color = "#eff1f5",
      bg_color = "#eff1f5",
    },
  },
}

config.window_frame = {
  active_titlebar_bg = "#bcc0cc",
  inactive_titlebar_bg = "#bcc0cc",
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
