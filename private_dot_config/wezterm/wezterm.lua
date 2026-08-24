local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action
local c = wezterm.config_builder()

-- --- Центрирование окна при старте ---
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {
    width = 120,
    height = 30,
  })
  local gui_window = window:gui_window()
  local screen = wezterm.gui.screens().main
  local dims = gui_window:get_dimensions()

  local x = math.floor((screen.width - dims.pixel_width) / 2)
  local y = math.floor((screen.height - dims.pixel_height) / 2)

  gui_window:set_position(x, y)
end)

-- --- Размеры окна ---
c.initial_cols = 120
c.initial_rows = 30

-- --- Шрифт ---
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
c.enable_tab_bar = false
c.hide_tab_bar_if_only_one_tab = true

-- --- Клавиатура (RU + EN через Virtual Key Codes) ---
c.keys = {
  -- Умный Ctrl+C: копирует, если есть выделение, иначе отправляет SIGINT
  {
    key = 'raw:67', -- C / С
    mods = 'CTRL',
    action = wezterm.action_callback(function(window, pane)
      local selection = window:get_selection_text_for_pane(pane)
      if selection and #selection > 0 then
        window:perform_action(act.CopyTo 'Clipboard', pane)
      else
        window:perform_action(act.SendKey { key = 'c', mods = 'CTRL' }, pane)
      end
    end),
  },

  -- Ctrl+Shift+C — всегда копировать
  {
    key = 'raw:67',
    mods = 'CTRL|SHIFT',
    action = act.CopyTo 'Clipboard',
  },

  -- Ctrl+Insert — копировать
  {
    key = 'Insert',
    mods = 'CTRL',
    action = act.CopyTo 'Clipboard',
  },

  -- Ctrl+V / Ctrl+М — вставка
  {
    key = 'raw:86', -- V / М
    mods = 'CTRL',
    action = act.PasteFrom 'Clipboard',
  },

  -- Ctrl+Shift+V — вставка (классика терминалов)
  {
    key = 'raw:86',
    mods = 'CTRL|SHIFT',
    action = act.PasteFrom 'Clipboard',
  },

  -- Shift+Insert — вставка
  {
    key = 'Insert',
    mods = 'SHIFT',
    action = act.PasteFrom 'Clipboard',
  },

  -- Ctrl+Q / Ctrl+Й — закрыть вкладку/окно
  {
    key = 'raw:81', -- Q / Й
    mods = 'CTRL',
    action = act.CloseCurrentTab { confirm = false },
  },

  -- Ctrl+Shift+Q — выйти из WezTerm
  {
    key = 'raw:81',
    mods = 'CTRL|SHIFT',
    action = act.QuitApplication,
  },

  -- Ctrl+Shift+F — полный экран
  {
    key = 'raw:70', -- F / А
    mods = 'CTRL|SHIFT',
    action = act.ToggleFullScreen,
  },

  -- Размер шрифта
  { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}

-- --- Мышь ---
c.mouse_bindings = {
  -- Левый клик
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor 'Cell',
  },
  -- Двойной клик — слово
  {
    event = { Down = { streak = 2, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor 'Word',
  },
  -- Тройной клик — строка
  {
    event = { Down = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor 'Line',
  },
  -- Тянем выделение
  {
    event = { Drag = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.ExtendSelectionToMouseCursor 'Cell',
  },
  -- Отпустили ЛКМ — копирование или открытие ссылки
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard',
  },
  {
    event = { Up = { streak = 2, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'Clipboard',
  },
  {
    event = { Up = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelection 'Clipboard',
  },
  -- Средняя и правая кнопки — вставка
  {
    event = { Down = { streak = 1, button = 'Middle' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom 'Clipboard',
  },
}

-- --- Оболочка ---
if wezterm.target_triple:find('windows') then
  c.default_prog = { 'pwsh.exe', '-NoExit' }
  c.default_cwd = wezterm.home_dir
else
  c.default_prog = { '/bin/bash', '--login' }
end

return c
