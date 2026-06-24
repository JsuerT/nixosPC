-- /etc/nixos/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- --- Schriftart ---
config.font = wezterm.font('JetBrains Mono')
config.font_size = 11.0

-- --- Fenster-Styling für Plasma 6 ---
config.window_decorations = "RESIZE"
-- config.window_background_opacity = 0.88
config.scrollback_lines = 5000

--padding
config.window_padding = {
  left = 15, 
  right = 15, 
  top = 15, 
  bottom = 30,
}

-- SILBER-LILA FARBSCHEMA ---
config.colors = {
  background = '#1e1d2f', 
  foreground = '#e2e4ec', 

  cursor_bg = '#b4befe',      
  cursor_fg = '#1e1d2f',      
  selection_bg = '#494d64',   
  selection_fg = '#f5c2e7',   
  
  split = '#8839ef',          

  ansi = {
    '#1e1e2e', '#f38ba8', '#a6e3a1', '#f9e2af',
    '#89b4fa', '#cba6f7', '#89dceb', '#a6adc8'
  },
  brights = {
    '#585b70', '#f38ba8', '#a6e3a1', '#f9e2af',
    '#89b4fa', '#cba6f7', '#89dceb', '#cdd6f4'
  },

  -- --- TAB-BAR STYLING ---
  tab_bar = {
    background = '#181825',

    active_tab = {
      bg_color = '#8839ef',   
      fg_color = '#ffffff',   
      intensity = 'Bold',
    },

    inactive_tab = {
      bg_color = '#313244',   
      fg_color = '#a6adc8',   
    },

    inactive_tab_hover = {
      bg_color = '#cba6f7',   
      fg_color = '#11111b',   
    },

    new_tab = {
      bg_color = '#313244',   
      fg_color = '#cba6f7',   
    },
    new_tab_hover = {
      bg_color = '#8839ef',   
      fg_color = '#ffffff',
    },
  },
}

-- --- Tab-Bar Feineinstellungen ---
config.enable_tab_bar = true
config.use_fancy_tab_bar = false 
config.tab_bar_at_bottom = false 


--shortcuts 
config.keys = {
  --neuertab
  {
    key = 't',
    mods = 'CTRL',
    action = wezterm.action.SpawnTab 'CurrentPaneDomain',
  },

  --schließen tab
  {
    key = 'w',
    mods = 'CTRL',
    action = wezterm.action.CloseCurrentTab { confirm = false },
  },

  --move
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
