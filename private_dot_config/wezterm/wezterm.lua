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
