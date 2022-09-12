{ config, pkgs, ... }:

{
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];

  services = {
    xserver = {
      videoDrivers = [ "intel" ];
    };
  };
}
