local wezterm = require 'wezterm'
local c = wezterm.config_builder()

-- CaskaydiaCove (лигатуры)
c.font = wezterm.font_with_fallback {
    'CaskaydiaCove Nerd Font',
    'CaskaydiaCove Nerd Font Mono',
    'Consolas',
}
c.font_size = 11.0
c.harfbuzz_features = { 'calt', 'liga', 'dlig' }

c.color_scheme = 'tokyonight'
c.window_background_opacity = 0.92
c.hide_tab_bar_if_only_one_tab = true

local home = os.getenv('USERPROFILE') or os.getenv('HOME')
c.font_dirs = { home .. '\\scoop\\apps\\Cascadia-Code\\current' }

if wezterm.target_triple:find('windows') then
    c.default_prog = { 'pwsh.exe', '--nologo' }
else
    c.default_prog = { '/bin/bash', '--login' }
end

return c
