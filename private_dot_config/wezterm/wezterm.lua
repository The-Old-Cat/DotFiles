local wezterm = require 'wezterm'
local c = wezterm.config_builder()

-- --- Шрифт (JetBrainsMono Nerd Font) ---
c.font = wezterm.font_with_fallback {
    'JetBrainsMono Nerd Font Mono',
    'JetBrainsMono Nerd Font',
    'CaskaydiaCove Nerd Font Mono',
    'Consolas',
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
    -- Копировать (Ctrl+C / Ctrl+Insert) — работа и в RU, и в EN
    { key = 'raw:67', mods = 'CTRL', action = wezterm.action.CopyTo 'Clipboard' }, -- VK_C (67)
    { key = 'Insert', mods = 'CTRL', action = wezterm.action.CopyTo 'Clipboard' },

    -- Вставить (Ctrl+V / Shift+Insert) — работает для Ctrl+V и Ctrl+М
    { key = 'raw:86', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' }, -- VK_V (86)
    { key = 'Insert', mods = 'SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },

    -- Закрыть терминал (Ctrl+Shift+Q) — работает для Ctrl+Shift+Q и Ctrl+Shift+Й
    { key = 'raw:81', mods = 'CTRL|SHIFT', action = wezterm.action.QuitApplication }, -- VK_Q (81)

    -- Закрыть окно (Ctrl+W) — работает для Ctrl+W и Ctrl+Ц
    { key = 'raw:87', mods = 'CTRL', action = wezterm.action.QuitApplication }, -- VK_W (87)

    -- Полноэкранный режим (Ctrl+Shift+F) — работает для Ctrl+Shift+F и Ctrl+Shift+А
    { key = 'raw:70', mods = 'CTRL|SHIFT', action = wezterm.action.ToggleFullScreen }, -- VK_F (70)

    -- Увеличение шрифта
    { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
    { key = '+', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
    { key = '=', mods = 'CTRL|SHIFT', action = wezterm.action.IncreaseFontSize },
    { key = '+', mods = 'CTRL|SHIFT', action = wezterm.action.IncreaseFontSize },

    -- Уменьшение шрифта
    { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },
    { key = '-', mods = 'CTRL|SHIFT', action = wezterm.action.DecreaseFontSize },

    -- Сброс размера шрифта (Ctrl+0)
    { key = '0', mods = 'CTRL', action = wezterm.action.ResetFontSize },
    { key = '0', mods = 'CTRL|SHIFT', action = wezterm.action.ResetFontSize },
}
-- --- Мышь ---
c.mouse_bindings = {
    -- Правый клик = вставка
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
