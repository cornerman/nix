{ config, pkgs, ... }:

{
  location = {
    latitude = 48.864716;
    longitude = 2.349014;
  };

  time.timeZone = "Europe/Amsterdam";

  console.keyMap = "us";
  i18n = {
  #   consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_TIME = "de_DE.UTF-8"; };
  };
}
