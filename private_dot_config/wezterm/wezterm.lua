local wezterm = require 'wezterm'
local c = wezterm.config_builder()

-- --- Шрифт (JetBrainsMono Nerd Font) ---
c.font = wezterm.font_with_fallback {
    'JetBrainsMono Nerd Font Mono',  -- Моноширинная версия
    'JetBrainsMono Nerd Font',       -- Стандартная
    'CaskaydiaCove Nerd Font Mono',  -- Запасной
    'Consolas',                      -- Системный резерв
}
c.font_size = 11.0
c.harfbuzz_features = { 'calt', 'liga', 'dlig' }

-- --- Цветовая схема ---
c.color_scheme = 'Tokyo Night'

-- --- Окно ---
c.window_background_opacity = 0.92
c.window_decorations = 'RESIZE'
c.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

-- --- Табы ---
c.hide_tab_bar_if_only_one_tab = true
c.enable_tab_bar = false

-- --- Клавиатура ---
c.keys = {
    { key = 'C', mods = 'CTRL', action = wezterm.action.CopyTo 'Clipboard' },
    { key = 'V', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
    { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
    { key = '+', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
    -- Полноэкранный режим
    { key = 'f', mods = 'CTRL|SHIFT', action = wezterm.action.ToggleFullScreen },
}

-- --- Мышь ---
c.mouse_bindings = {
    { event = { Down = { streak = 1, button = 'Right' } },
      action = wezterm.action.PasteFrom 'Clipboard' },
}

-- --- Оболочка ---
if wezterm.target_triple:find('windows') then
    c.default_prog = { 'pwsh.exe', '-NoExit' }
else
    c.default_prog = { '/bin/bash', '--login' }
end

return c
