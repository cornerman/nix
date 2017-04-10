# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    initrd.luks.devices.crypted.device = "/dev/nvme0n1p2";

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "/dev/nvme0n1";
    };
  };


  # Select internationalisation properties.
  i18n = {
  #   consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  networking = {
    hostName = "talent";
    networkmanager.enable = true;
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    htop
    gnupg
    ncmpcpp
    tmux
    tmate

    neovim
    git
    tig
    ag
    gnumake
    gcc
    clang
    sbt
    scala
    yarn
    nodejs
    docker
    docker_compose

    xorg.xinit
    xorg.xauth
    xorg.xev
    i3
    i3status
    autocutsel
    unclutter
    redshift
    rxvt_unicode
    rofi
    xdotool
    #xcwd
    #atril
    firefox
    chromium
    thunderbird
    networkmanagerapplet

    dejavu_fonts
    ubuntu_font_family
    tango-icon-theme
    numix-gtk-theme
    font-awesome-ttf
  ];

  programs = {
    zsh.enable = true;
  };

  virtualisation.docker.enable = true;

  services = {
    openssh.enable = false; #TODO config
    printing.enable = true;

    xserver = {
      autorun = false;
      enable = true;
      enableTCP = false;
      exportConfiguration = true;

      layout = "us";
      xkbOptions = "eurosign:e";

      synaptics.enable = true;

      # windowManager = {
      #   i3.enable = true;
      #   default = "i3";
      # };

      # desktopManager = {
      #   xterm.enable = false;
      #   default = "none";
      # };

      displayManager = {
        slim.enable = false;
        job.execCmd = "";
      };
    };
  };

  users.extraUsers.cornerman = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";
}
