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
      let g:airline_theme = "solarized"
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

      "" alles für die leiste oben 
      " Fixierte obere Leiste aktivieren
      set showtabline=2

      " Standard-Text, falls noch kein Kapitel gesetzt wurde
      let g:kasten_default = "Kein Inhaltsverzeichnis"

      " Funktion, die den Text für die obere Leiste holt
      function! AktuellerKastenText()
        return get(b:, "mein_kasten_text", g:kasten_default)
      endfunction

      " Funktion zum Hinzufügen von Kapiteln
      function! KastenHinzufuegen(neuer_text)
        if !exists("b:mein_kasten_text") || b:mein_kasten_text == g:kasten_default
          let b:mein_kasten_text = a:neuer_text
        else
          let b:mein_kasten_text = b:mein_kasten_text . " | " . a:neuer_text
        endif
        redrawtabline
      endfunction

      " Befehle für den User
      command! -nargs=+ Kasten call KastenHinzufuegen(<q-args>)
      command! KastenReset unlet! b:mein_kasten_text | redrawtabline

      " --- AUTOMATISCHES SPEICHERN & LADEN ---

      " 1. Beim Öffnen einer Datei: Suche nach dem gespeicherten Inhaltsverzeichnis in den letzten 5 Zeilen
      autocmd BufReadPost * call KastenLaden()
      function! KastenLaden()
        let l:letzte_zeilen = getline(max([1, line("$")-4]), line("$"))
        for l:zeile in l:letzte_zeilen
          let l:match = matchlist(l:zeile, "VIM_KASTEN:\\s*\\(.*\\)")
          if !empty(l:match) && !empty(l:match[1])
            let b:mein_kasten_text = l:match[1]
            redrawtabline
            break
          endif
        endfor
      endfunction

      " 2. Beim Speichern der Datei: Aktualisiere oder hänge die Zeile ganz unten an
      autocmd BufWritePre * call KastenSpeichern()
      function! KastenSpeichern()
        if exists("b:mein_kasten_text") && b:mein_kasten_text != g:kasten_default
          " Bestimme das Kommentarzeichen je nach Dateityp
          let l:comment = substitute(&commentstring, "%s", "", "")
          if empty(l:comment) | let l:comment = "# " | endif
          
          let l:neue_speicherzeile = trim(l:comment) . " VIM_KASTEN: " . b:mein_kasten_text
          
          " Prüfen, ob schon ein Eintrag in den letzten 3 Zeilen existiert
          let l:line_num = line("$")
          while l:line_num > max([1, line("$")-3])
            if getline(l:line_num) =~ "VIM_KASTEN:"
              call setline(l:line_num, l:neue_speicherzeile)
              return
            endif
            let l:line_num -= 1
          endwhile
          
          " Falls kein Eintrag existiert, füge ihn ganz unten hinzu
          call append(line("$"), l:neue_speicherzeile)
        endif
      endfunction

      " Das Layout der oberen Leiste
      set tabline=%#Visual#\ \|\ Inhaltsverzeichnis:\ %{AktuellerKastenText()}\ \|\ 
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

  # Kernel-Fix gegen die Bluetooth-Abstürze
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

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

  # Audio (PipeWire)
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="*", ATTR{idProduct}=="*", ATTR{product}=="*Bluetooth*", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", DRIVER=="btusb", ATTR{power/control}="on"
  '';   

  # Bluetooth & Blueman
  hardware.bluetooth = {
    enable = true;   
    powerOnBoot = true;   
    settings = {
      General = {
        ControllerMode = "dual";
        FastConnectable = true;
        Experimental = true;
      };
    };
  };
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
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];   
    packages = with pkgs; [ ];
  };

  # Programs
  programs.firefox.enable = true;
  programs.nm-applet.enable = true;
  programs.mtr.enable = true;
  programs.gamescope.enable = true;  
  programs.adb.enable = true;

  # Steam Aktivierung
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

    libreoffice
    blender

    myVim
    spotify
    discord
    unityhub
  ];

  environment.shellAliases = {
    bye = "shutdown now";
    steamapps = "cd ~/.local/share/Steam/steamapps/common";
    list = ''
      for c in $(ls | cut -c1 | sort -u); do
        echo "$c"
        ls | grep "^$c" | sed 's/^/├── /'
        echo
      done
    '';
    Ergo = "cd /run/media/ticco/INTENSO/SchuleErgo";
    Info = "cd /run/media/ticco/INTENSO/StudiumIT";
  };

  # Default editor
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  system.stateVersion = "24.11";
}
