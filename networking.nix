# Edit this configuration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).  
{ config, pkgs, ... }:

{
  networking = {
    hostName = "genius";
    networkmanager.enable = true;

    #wireless.userControlled.enable = true;
    #wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # firewall.allowedTCPPorts = [ 12345 ];
    # firewall.allowedUDPPorts = [ ... ];
    # firewall.enable = false;

    extraHosts = ''
    '';

    nameservers =
      [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
  };
}
