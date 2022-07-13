{ config, pkgs, ... }:

{
  imports =
    [
      (fetchGit { url = "https://github.com/cornerman/shadow-nix"; ref = "master"; } + "/import/system.nix") #SHADOW
    ];

  programs.shadow-client = {
    # Enabled by default when using import
    # enable = true;
    # channel = "prod";
    channel = "preprod";
  };
  # Hardware hybrid decoding
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  # Hardware drivers
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };
  environment.systemPackages = with pkgs; [
    libva-utils
    libvdpau
  ];
}
