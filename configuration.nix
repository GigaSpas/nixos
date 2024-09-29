{ config, pkgs, ... }:

{
  imports =
    [
    ./hardware-configuration.nix
    ];


# Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint= "/boot";
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
#networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# Enable networking
    networking.networkmanager.enable = true;

# Enable network manager applet
  programs.nm-applet.enable = true;

# Set your time zone.
  time.timeZone = "Europe/Sofia";

# Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "bg_BG.UTF-8";
    LC_IDENTIFICATION = "bg_BG.UTF-8";
    LC_MEASUREMENT = "bg_BG.UTF-8";
    LC_MONETARY = "bg_BG.UTF-8";
    LC_NAME = "bg_BG.UTF-8";
    LC_NUMERIC = "bg_BG.UTF-8";
    LC_PAPER = "bg_BG.UTF-8";
    LC_TELEPHONE = "bg_BG.UTF-8";
    LC_TIME = "bg_BG.UTF-8";
  };

# Enable the X11 windowing system.
  services.xserver.enable = true;


# Enable OpenGL
  hardware.opengl = {
    enable = true;
  };
#boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];



# Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia"];

  hardware.nvidia = {

# Modesetting is required.
    modesetting.enable = true;

# Nvidia power management. Experimental, and can cause sleep/suspend to fail.
# Enable this if you have graphical corruption issues or application crashes after waking
# up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
# of just the bare essentials.
    powerManagement.enable = false;

# Fine-grained power management. Turns off GPU when not in use.
# Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

# Use the NVidia open source kernel module (not to be confused with the
# independent third-party "nouveau" open source driver).
# Support is limited to the Turing and later architectures. Full list of 
# supported GPUs is at: 
# https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
# Only available from driver 515.43.04+
# Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

# Enable the Nvidia settings menu,
# accessible via `nvidia-settings`.
    nvidiaSettings = true;

# Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
# Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

#services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
#HYPRLAND
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

# Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
# If you want to use JACK applications, uncomment this
#jack.enable = true;

# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#media-session.enable = true;
  };

  services.libinput.enable = true;

  users.users.spas = {
    isNormalUser = true;
    description = "Spas";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };


  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "CommitMono" ]; })
  ];


  nixpkgs.config.allowUnfree = true;

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
      thunar-volman
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

# List packages installed in system profile. To search, run:
# $ nix search wget
  environment.systemPackages = with pkgs; [
#tools
    neovim
      zoxide
      ripgrep
      bat
      fzf
      btop
      syncthing
      rofi-wayland
      git
      lshw
      qbittorrent
      ventoy
      brightnessctl
      dunst
      libnotify
      cliphist
      libsForQt5.polkit-kde-agent

#wine
      wineWowPackages.stable
      winetricks


#customization
      starship
      hyprpicker
      hyprpaper
      waybar
      (pkgs.waybar.overrideAttrs (oldAttrs: {
                                  mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
                                  })
      )
#programs
      kitty
      nushell
      keepassxc
      xarchiver
      neofetch
      firefox
      discord
      pavucontrol
      lutris
      ];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

}

