{ config, pkgs, ... }:

{
  users = {
    extraGroups.vboxusers.members = [ "cornerman" ];

    extraUsers.cornerman = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "video" "audio" "docker" "networkmanager" "adbusers" ];
      shell = "/run/current-system/sw/bin/zsh";
    };
  };
}
