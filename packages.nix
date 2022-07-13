{ config, pkgs, ... }:

{
  documentation = {
    enable = false;
    man.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
    chromium = {
      # enablePepperFlash = true;
      # enablePepperPDF = true;
      enableWideVine = true;
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    neovim
    git
    tig
    silver-searcher
    gnumake
    gcc
    clang
    pmount
    light
    wget
    htop
    gnupg
    fzf

    # pinentry-curses

    slock
    xorg.xinit
    xorg.xauth
    xorg.xev
    python3
    python37Packages.virtualenv
    python37Packages.py3status
    i3
    i3status
    xorg.xmodmap
    xdg_utils
    shared-mime-info
    desktop-file-utils
    vanilla-dmz

    # Themes
    tango-icon-theme
    numix-icon-theme-square #-icon
    numix-gtk-theme
    numix-cursor-theme
    # numix-solarized-gtk-theme
    font-awesome
    # dconf

    # unclutter
    xss-lock
  ];

  programs = {
    adb.enable = true;
    ssh.startAgent = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };

    zsh = {
	    enable = true;
	    interactiveShellInit = ''
		source "${pkgs.fzf}/share/fzf/completion.zsh"
		source "${pkgs.fzf}/share/fzf/key-bindings.zsh"
	      '';
    };
  };

  virtualisation = {
    #virtualbox = {
    #  host.enable = true;
    #  host.enableExtensionPack = true;
    #};

    docker.enable = true;
  };

  security = {
    # rtkit.enable = false;
    polkit.enable = true;
    # wrappers = {
    #   pmount.source = "${pkgs.pmount}/bin/pmount";
    #   pumount.source = "${pkgs.pmount}/bin/pumount";
    #   light.source = "${pkgs.light}/bin/light";
    #   slock.source = "${pkgs.slock}/bin/slock";
    # };
  };
}
