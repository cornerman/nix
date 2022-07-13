{ config, pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts # Arial, Verdana, ...
      vistafonts # Consolas, ...
      google-fonts # Droid Sans, Roboto, ...
      ubuntu_font_family
      dejavu_fonts
      symbola # unicode symbols
      powerline-fonts
    ];
    fontconfig = {
      includeUserConf = false;
      defaultFonts.monospace = [ "Inconsolata" "DejaVu Sans Mono" ];
    };
  };
}
