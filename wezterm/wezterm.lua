-- ~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.enable_wayland = true
config.term = 'wezterm'
config.font = wezterm.font 'Cascadia Code'
config.font_size = 12.0
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.font_rules = {
  {
    italic = true,
    font = wezterm.font { family = 'Cascadia Code', italic = true },
  },
}
config.initial_cols = 120
config.initial_rows = 30
config.color_scheme = 'Kanagawa (Gogh)'
config.window_decorations = "NONE"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

return config
