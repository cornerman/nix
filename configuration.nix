# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
    sane.enable = true;

    cpu.intel.updateMicrocode = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
    initrd.luks.devices.crypted.device = "/dev/nvme0n1p2";

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub.device = "/dev/nvme0n1";
    };

    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "vm.swappiness" = 0;
    };

    tmpOnTmpfs = true;
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

    firewall.allowedTCPPorts = [ 12345 ];
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
    
    extraHosts = ''
      192.168.0.80 genius
      192.168.0.94 talent
      192.168.0.143 hive
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
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
    fzf

    xdg_utils
    shared_mime_info # file-type associations?
    desktop_file_utils

    speedtest-cli
    neovim
    python2
    python3
    python37Packages.py3status

    keepassxc
    

    imagemagick
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
    docker-edge
    docker_compose
    pmount

    slock
    xorg.xinit
    xorg.xauth
    xorg.xev
    i3
    i3status
    xorg.xmodmap

    autocutsel
    unclutter
    redshift
    rxvt_unicode
    rofi
    xdotool
    xss-lock
    xcwd
    mate.atril
    # evince
    arandr
    firefox
    chromium
    pcmanfm
    thunderbird
    networkmanagerapplet
    signal-desktop

    tango-icon-theme
    numix-gtk-theme
    font-awesome-ttf
  ];

  programs = {
    adb.enable = true;
    # gnupg.agent.enableSSHSupport = true;
    ssh.startAgent = true;
    zsh.enable = true;
  };

  virtualisation.docker.enable = true;

  services = {
    # fstrim.enable = true;
    locate.enable = true;

    upower.enable  = true;
    gnome3.gvfs.enable  = true;
    #gnome3.gnome-keyring.enable = true;
    udisks2.enable = true;

    usbmuxd.enable = true; # ios debugging

    journald = {
      extraConfig =
      ''
      Storage=persist
      Compress=yes
      SystemMaxUse=128M
      RuntimeMaxUse=8M
      '';
    };

    openssh = {
      enable = false;
      passwordAuthentication = false;
    };

    # Redshift adjusts the color temperature of your screen according to your surroundings. This may help your eyes hurt less if you are working in front of the screen at night.
    redshift = {
      enable = true;
      latitude = "50.77";
      longitude = "6.08";
    };

    # hide mouse after some seconds of no movement
    unclutter-xfixes.enable = true;

    acpid.enable = true;
    # udev.extraRules = ''
      # SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-7]", RUN+="/run/current-system/sw/bin/systemctl hibernate"
    # '';

    syncthing = {
      enable = true;
      user = "cornerman";
      dataDir = "/home/cornerman/.config/syncthing";
      openDefaultPorts = true;
    };

    keybase = {
      enable = true;
    };
    kbfs = {
      enable = true;
      mountPoint = "/keybase"; # mountpoint important for keybase-gui
    };

    # btsync = {
    #   enable = true;
    #   enableWebUI = true;
    #   package = pkgs.bittorrentSync20;
    # };


    #clamav = {
    #  daemon.enable   = true;
    #  daemon.extraConfig = ''
    #    TCPAddr   127.0.0.1
    #    TCPSocket 3310
    #  '';
    #  updater.enable  = true;
    #};

    # ipfs = {
    #   enable = true;
    # };


    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint pkgs.hplip pkgs.epson-escpr ];
    };
    logind.extraConfig = "HandleLidSwitch=ignore";

    xserver = {
      dpi = 176;
      # synaptics.enable = true;
      libinput = {
        enable = true;
        scrollMethod = "twofinger";
        disableWhileTyping = true;
        tapping = false;
      };

      autorun = false;
      enable = true;
      enableTCP = false;
      exportConfiguration = true;

      layout = "us";
      xkbOptions = "eurosign:e";

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
        # job.execCmd = "";
      };
    };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      google-fonts
      ubuntu_font_family
      dejavu_fonts
      symbola # unicode symbols
    ];
    fontconfig = {
      includeUserConf = false;
      defaultFonts.monospace = [ "Inconsolata" "DejaVu Sans Mono" ];
    };
  };

  powerManagement = {
    enable = true;
    # powertop.enable = true;
  };

  users.extraUsers.cornerman = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "networkmanager" "adbusers" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  nix.gc.automatic = true;
  nix.gc.dates = "12:15";
  nix.gc.options = "--delete-older-than 7d";
  nix.daemonIONiceLevel = 7;
  nix.daemonNiceLevel = 19;

  security = {
    wrappers = {
      pmount.source = "${pkgs.pmount}/bin/pmount";
      pumount.source = "${pkgs.pmount}/bin/pumount";
      # light.source = "${pkgs.light}/bin/light";
      slock.source = "${pkgs.slock}/bin/slock";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

  fileSystems."/media/woost/data" =
    {
      device = "//DeathStar/Data";
      fsType = "cifs";
      options = [
        "uid=cornerman"
        "gid=users"
        "workgroup=woost"
        "username=wust"
        "password=woostyourself."
        "x-systemd.automount"
        "noauto"
        "_netdev"
        "x-systemd.requires=network-online.target"
        "x-systemd.device-timeout=30"
      ];
    };
}
