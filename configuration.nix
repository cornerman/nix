# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).  
{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./networking.nix
      ./packages.nix
      ./services.nix
      ./fonts.nix
      ./users.nix
      ./services.nix
      ./nvidia.nix
      ./shadow.nix
      ./localization.nix
    ];

  hardware = {
    sane.enable = true;
    bluetooth.enable = true;

    cpu.intel.updateMicrocode = true;
  };

  boot = {
    initrd.luks.devices.crypted.device = "/dev/nvme0n1p7";
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    kernelPackages = pkgs.linuxPackages_latest;

    kernel.sysctl = {
      "kernel.sysrq" = 1;
      "vm.swappiness" = 0;
      "fs.inotify.max_user_watches" = 524288;
    };

    tmpOnTmpfs = true;

    # extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];
    # extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ];
  };

  nix = {
    #TODO: https://github.com/NixOS/nix/issues/6572
    package = pkgs.nixVersions.nix_2_7;

    gc = {
      automatic = true;
      dates = "12:15";
      options = "--delete-older-than 7d";
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
    };

    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    stateVersion = "22.05"; # Did you read the comment?
  };
}
