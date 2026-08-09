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

-- --- INTENSIVES PURPLE RAIN / DARK ROSA FARBSCHEMA ---
config.colors = {
  background = '#1b0e1e',     -- Dunkler Pflaumen-Hintergrund
  foreground = '#f2b4ce',     -- Hauptschrift: Klar wahrnehmbares Pastellrosa statt Weiß

  cursor_bg = '#f07db4',      -- Strahlendes Pink/Rosa für den Cursor
  cursor_fg = '#1b0e1e',      
  cursor_border = '#f07db4',

  selection_bg = '#5c224a',   -- Kräftiges Beeren-Violett beim Markieren
  selection_fg = '#ffd6e7',   

  split = '#e85a9d',          -- Akzent-Rosa für Fenster-Splits

  -- ANSI-Farben: Grün, Blau etc. durch Rosatöne ersetzt, 
  -- damit auch Konsolen-Prompts und System-Logs rosa leuchten
  ansi = {
    '#1b0e1e', -- Black
    '#f07db4', -- Red (Beeren-Pink)
    '#e58cb3', -- Green -> Ersetzt durch Rose/Magenta (Prompt-Farbe!)
    '#f7a3c7', -- Yellow -> Soft Pink
    '#d670a6', -- Blue -> Altrosa
    '#e85a9d', -- Magenta -> Kräftiges Pink
    '#f2b4ce', -- Cyan -> Hellrosa
    '#f7d6e4'  -- White -> Sehr helles Rosa
  },
  brights = {
    '#3e203f', -- Bright Black
    '#ff8dc3', -- Bright Red
    '#fba2cd', -- Bright Green -> Hell-Pink
    '#fbc4dd', -- Bright Yellow
    '#e882ba', -- Bright Blue
    '#ff6eb4', -- Bright Magenta
    '#f2c2d7', -- Bright Cyan
    '#ffffff'  -- Bright White
  },

  -- --- TAB-BAR STYLING ---
  tab_bar = {
    background = '#130915',   -- Dunkler Ton für die Tab-Leiste

    active_tab = {
      bg_color = '#e85a9d',   -- Kräftiges Rosa für aktiven Tab
      fg_color = '#ffffff',   
      intensity = 'Bold',
    },

    inactive_tab = {
      bg_color = '#381c37',   -- Gedämpftes Dunkel-Violett für inaktive Tabs
      fg_color = '#f2b4ce',   -- Rosa Schrift für inaktive Tabs
    },

    inactive_tab_hover = {
      bg_color = '#f07db4',   -- Helleres Pink beim Drüberfahren
      fg_color = '#1b0e1e',   
    },

    new_tab = {
      bg_color = '#381c37',   
      fg_color = '#f2b4ce',   
    },
    new_tab_hover = {
      bg_color = '#e85a9d',   
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
