local wezterm = require 'wezterm'
local mux = wezterm.mux
local c = wezterm.config_builder()

-- --- Размеры окна при запуске (в символах) ---
local INITIAL_COLS = 120
local INITIAL_ROWS = 30

-- --- Центрирование окна при старте ---
wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    local gui_window = window:gui_window()

    gui_window:set_inner_size(INITIAL_COLS, INITIAL_ROWS)

    local screen = wezterm.gui.screens().main
    local window_dimensions = gui_window:get_dimensions()

    local x = (screen.width - window_dimensions.pixel_width) / 2
    local y = (screen.height - window_dimensions.pixel_height) / 2

    gui_window:set_position(x, y)
end)

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
c.window_close_confirmation = 'NeverPrompt'
c.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
}

-- --- Табы ---
c.hide_tab_bar_if_only_one_tab = true
c.enable_tab_bar = false

-- --- Клавиатура (поддержка RU и EN раскладок через Virtual Key Codes) ---
c.keys = {
    -- Копировать (Ctrl+C / Ctrl+С)
    { key = 'raw:67', mods = 'CTRL', action = wezterm.action.CopyTo 'Clipboard' },
    { key = 'Insert', mods = 'CTRL', action = wezterm.action.CopyTo 'Clipboard' },

    -- Вставить (Ctrl+V / Ctrl+М)
    { key = 'raw:86', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },
    { key = 'Insert', mods = 'SHIFT', action = wezterm.action.PasteFrom 'Clipboard' },

    -- Закрыть окно (Ctrl+Q / Ctrl+Й)
    { key = 'raw:81', mods = 'CTRL', action = wezterm.action.CloseCurrentTab { confirm = false } },

    -- Закрыть приложение целиком (Ctrl+Shift+Q / Ctrl+Shift+Й)
    { key = 'raw:81', mods = 'CTRL|SHIFT', action = wezterm.action.QuitApplication },

    -- Полноэкранный режим (Ctrl+Shift+F / Ctrl+Shift+А)
    { key = 'raw:70', mods = 'CTRL|SHIFT', action = wezterm.action.ToggleFullScreen },

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
    -- Выделение мышью = автоматическое копирование в буфер обмена
    {
        event = { Up = { streak = 1, button = 'Left' } },
        mods = 'NONE',
        action = wezterm.action.CompleteSelection 'Clipboard',
    },

    -- Правый клик = вставка
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'NONE',
        action = wezterm.action.PasteFrom 'Clipboard',
    },
}

-- --- Оболочка ---
if wezterm.target_triple:find('windows') then
    c.default_prog = { 'pwsh.exe', '-NoExit' }
else
    c.default_prog = { '/bin/bash', '--login' }
end

return c
