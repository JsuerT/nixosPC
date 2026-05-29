{ config, pkgs, ... }:

let
  myVim = pkgs.vim-full.customize {
    name = "vim";
    vimrcConfig.packages.myVimPackage = {
      start = with pkgs.vimPlugins; [
        vim-airline
        vim-airline-themes
        nerdtree
        vim-fugitive
        vim-gitgutter
        vim-surround
        vim-commentary
        fzf-vim
        vim-polyglot
        indentLine
        auto-pairs
        vim-autoformat
        vim-colors-solarized
      ];
    };
    vimrcConfig.customRC = ''
      syntax on
      set number
      set relativenumber
      set termguicolors
      set encoding=utf-8
      set shiftwidth=2
      set tabstop=2
      set softtabstop=2
      set expandtab
      set mouse=a
      set hidden
      set clipboard=unnamedplus
      set updatetime=300
      set signcolumn=yes

      " Solarized Dark
      set background=dark
      let g:solarized_termcolors = 256
      let g:solarized_use16 = 1
      colorscheme solarized

      " Airline
      let g:airline_theme = 'solarized'
      let g:airline_powerline_fonts = 1

      " Leader
      let mapleader = " "

      " NERDTree
      nnoremap <C-n> :NERDTreeToggle<CR>

      " File search
      nnoremap <leader>ff :Files<CR>
      nnoremap <leader>fg :GFiles<CR>

      " Autoformat
      nnoremap <F3> :Autoformat<CR>
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname and networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time and locale
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Graphical desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  console.keyMap = "de";

  # Printing
  services.printing.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  #bluetooth 
  hardware.bluetooth.enable = true; 
  hardware.bluetooth.powerOnBoot = true; 
  services.blueman.enable = true;

  # Touchpad / input
  services.libinput.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrains Mono" ];
  };

  # User
  users.users.ticco = {
    isNormalUser = true;
    description = "ticco";
    # Hinweis: Falls ADB weiterhin "no permissions" zeigt, füge hier noch "adbusers" hinzu.
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ]; 
    packages = with pkgs; [ ];
  };

  # Programs
  programs.firefox.enable = true;
  programs.nm-applet.enable = true;
  programs.mtr.enable = true;
  programs.gamescope.enable = true; 
  programs.adb.enable = true;

  # --- NEU: Steam Aktivierung ---
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true; 
  };

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Database
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    subversion
    curl
    wget
    htop
    btop
    tree
    ripgrep
    fd
    unzip
    zip
    
    dotnet-sdk_8            
    mariadb
    openjdk21
    openjdk17
    android-tools
    nodePackages.prettier
    python3Packages.black
    clang-tools
    shfmt
    zoxide
    
    wineWowPackages.stable
    r2modman
    htop

    libreoffice
    blender

    myVim
    spotify
    discord
    unityhub
  ];

  environment.shellAliases={
    steamapps = "cd ~/.local/share/Steam/steamapps/common";
    bye = "shutdown now";
    ergo="cd /run/media/ticco/INTENSO/SchuleErgo";
    info="cd /run/media/ticco/INTENSO/Info";
  };

  # Default editor
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  system.stateVersion = "24.11";
}
