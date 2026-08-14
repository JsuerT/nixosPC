local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- größe von dem startfenster 
config.initial_cols = 120 
config.initial_rows = 35

-- --- Schriftart ---
config.font = wezterm.font('JetBrains Mono')
config.font_size = 11.0

-- --- Fenster-Styling für Plasma 6 ---
config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.88
config.scrollback_lines = 5000

-- padding
config.window_padding = {
  left = 15, 
  right = 15, 
  top = 15, 
  bottom = 30,
}

-- --- DEEP NIGHT SKY / ELECTRIC BLUE FARBSCHEMA ---
config.colors = {
  background = '#0a1128',     -- Dunkles Nachtblau-Hintergrund
  foreground = '#a9d6f5',     -- Hauptschrift: Klares Pastellblau

  cursor_bg = '#2e9bf0',      -- Strahlendes Himmelblau für den Cursor
  cursor_fg = '#0a1128',      
  cursor_border = '#2e9bf0',

  selection_bg = '#1c3f6e',   -- Kräftiges Dunkelblau beim Markieren
  selection_fg = '#d6ecff',   

  split = '#1f8fe0',          -- Akzent-Blau für Fenster-Splits

  -- ANSI-Farben: durch Blautöne ersetzt, 
  -- damit auch Konsolen-Prompts und System-Logs blau leuchten
  ansi = {
    '#0a1128', -- Black
    '#2e9bf0', -- Red -> Himmelblau
    '#1a6fc4', -- Green -> Mittelblau
    '#4db8ff', -- Yellow -> Helles Blau
    '#0d3b73', -- Blue -> Marineblau
    '#1f8fe0', -- Magenta -> Kräftiges Blau
    '#a9d6f5', -- Cyan -> Hellblau
    '#d6ecff'  -- White -> Sehr helles Blau
  },
  brights = {
    '#1c3f6e', -- Bright Black
    '#5ec2ff', -- Bright Red
    '#3fa9f5', -- Bright Green
    '#7dd0ff', -- Bright Yellow
    '#2e78d6', -- Bright Blue
    '#4fb0ff', -- Bright Magenta
    '#c2e6ff', -- Bright Cyan
    '#ffffff'  -- Bright White
  },

  -- --- TAB-BAR STYLING ---
  tab_bar = {
    background = '#060b1a',   -- Dunkler Ton für die Tab-Leiste

    active_tab = {
      bg_color = '#1f8fe0',   -- Kräftiges Blau für aktiven Tab
      fg_color = '#ffffff',   
      intensity = 'Bold',
    },

    inactive_tab = {
      bg_color = '#122344',   -- Gedämpftes Dunkelblau für inaktive Tabs
      fg_color = '#a9d6f5',   -- Blaue Schrift für inaktive Tabs
    },

    inactive_tab_hover = {
      bg_color = '#2e9bf0',   -- Helleres Blau beim Drüberfahren
      fg_color = '#0a1128',   
    },

    new_tab = {
      bg_color = '#122344',   
      fg_color = '#a9d6f5',   
    },
    new_tab_hover = {
      bg_color = '#1f8fe0',   
      fg_color = '#ffffff',
    },
  },
}

-- --- Tab-Bar Feineinstellungen ---
config.enable_tab_bar = true
config.use_fancy_tab_bar = false 
config.tab_bar_at_bottom = false 

-- shortcuts 
config.keys = {
  -- neuer tab
  {
    key = 't',
    mods = 'CTRL',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },

  -- schließen tab
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },

  -- move
  {
    key = 'Tab',
    mods = 'CTRL',
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = 'Tab',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.ActivateTabRelative(-1),
  },
}

return config
