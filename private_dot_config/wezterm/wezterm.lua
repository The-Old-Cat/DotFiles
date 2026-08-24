local wezterm = require 'wezterm'
local c = wezterm.config_builder()

-- Шрифт + лигатуры
c.font = wezterm.font_with_fallback { 'Hasklug Nerd Font Mono', 'Consolas' }
c.font_size = 11.0
c.harfbuzz_features = { 'calt', 'liga', 'dlig' }

-- Tokyo Night (встроенная схема)
c.color_scheme = 'tokyonight'
c.window_background_opacity = 0.92
c.hide_tab_bar_if_only_one_tab = true

-- ОС-ветвление без chezmoi-шаблонов
if wezterm.target_triple:find('windows') then
    c.default_prog = { 'pwsh.exe', '--nologo' }
else
    c.default_prog = { '/bin/bash', '--login' }
end

return c
