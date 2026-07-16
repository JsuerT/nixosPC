{ config, pkgs, ... }:

let
  myVim = import ./vim.nix {inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #Kernel wechseln
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
  '';

# 1. Erlaube und erzwinge die aktuellste redistribution-Firmware
  hardware.enableRedistributableFirmware = true;

  # 2. Treiber-Optionen für den MediaTek-Bluetooth-Chip (btusb) setzen
  boot.extraModprobeConfig = ''
    options btusb enable_autosuspend=0
  '';

  # Bluetooth & Blueman
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        Enables = "Source,Sink,Media,Socket";
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

  #VM
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  services.spice-vdagentd.enable = true;

  # Steam Aktivierung
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
  hardware.steam-hardware.enable = true; 

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Database
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    wezterm
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
    wine
    r2modman

    tty-clock
    termdown
    libreoffice
    blender

    myVim
    spotify
    discord
    unityhub
  ];
  environment.etc."xdg/wezterm/wezterm.lua".source = ./wezterm.lua;

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
    Ergo = "udisksctl mount -b /dev/disk/by-label/INTENSO 2>/dev/null; cd /run/media/ticco/INTENSO/SchuleErgo";
    Info = "udisksctl mount -b /dev/disk/by-label/INTENSO 2>/dev/null; cd /run/media/ticco/INTENSO/StudiumIT";
    rmdown = "rm -rf ~/Downloads&& mkdir Downloads";
  };

  # Default editor
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  system.stateVersion = "24.11";
}
