{ config, pkgs, ... }:

{
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;

      config.pipewire-pulse = {
        "stream.properties" = {
          "resample.quality" = 10;
        };
      };

      config.client = {
        "stream.properties" = {
          "resample.quality" = 10;
        };
      };

      config.pipewire = {
        "context.properties" = {
          #"link.max-buffers" = 64;
          # "link.max-buffers" = 16; # version < 3 clients can't handle more than this
          #"log.level" = 2; # https://docs.pipewire.org/#Logging
          #"default.clock.rate" = 192000;
          #"default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
          #"default.clock.quantum" = 1024;
          #"default.clock.min-quantum" = 32;
          #"default.clock.max-quantum" = 8192;
        };
      };

      media-session.config.bluez-monitor.rules = [
        {
          # Matches all cards
          matches = [ { "device.name" = "~bluez_card.*"; } ];
          actions = {
            "update-props" = {
              "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
              # mSBC is not expected to work on all headset + adapter combinations.
              "bluez5.msbc-support" = true;
              # SBC-XQ is not expected to work on all headset + adapter combinations.
              "bluez5.sbc-xq-support" = true;
              "bluez5.msbc-force-mtu" = true;
            };
          };
        }
        {
          matches = [
            # Matches all sources
            { "node.name" = "~bluez_input.*"; }
            # Matches all outputs
            { "node.name" = "~bluez_output.*"; }
          ];
          actions = {
            "node.pause-on-idle" = false;
          };
        }
      ];
    };

    ntp.enable = true;
    fstrim.enable = true;
    locate.enable = true;

    upower.enable  = true;
    gvfs.enable  = true;
    #gnome3.gnome-keyring.enable = true;
    udisks2.enable = true;

    usbmuxd.enable = true; # ios debugging

    blueman.enable = true;

    tlp = {
      enable = true;
      settings = {
        tlp_DEFAULT_MODE = "AC";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
      };
    };

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
      forwardX11 = true;
    };

    # Redshift adjusts the color temperature of your screen according to your surroundings. This may help your eyes hurt less if you are working in front of the screen at night.
    redshift = {
      enable = true;
    };

    # hide mouse after some seconds of no movement
    unclutter-xfixes.enable = false;

    acpid.enable = true;
    # udev.extraRules = ''
      # SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", ATTR{capacity}=="[0-7]", RUN+="/run/current-system/sw/bin/systemctl hibernate"
    # '';

    psd = {
      enable = true;
    };

    syncthing = {
      enable = true;
      user = "cornerman";
      dataDir = "/home/cornerman/.config/syncthing";
      openDefaultPorts = true;
    };

    # keybase = {
    #   enable = true;
    # };
    # kbfs = {
    #   enable = true;
    #   mountPoint = "/keybase"; # mountpoint important for keybase-gui
    # };

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

    # printing = {
    #   enable = true;
    #   drivers = [ pkgs.gutenprint pkgs.hplip pkgs.epson-escpr ];
    # };

    # logind.extraConfig = "HandleLidSwitch=ignore";

    xserver = {
      # dpi = 210;
      libinput.enable = true;
      libinput.touchpad = {
        sendEventsMode = "disabled-on-external-mouse";
        scrollMethod = "twofinger";
        disableWhileTyping = true;
        tapping = false;
        accelSpeed = "0.6";
      };

      autorun = false;
      enable = true;
      enableTCP = false;
      exportConfiguration = true;

      layout = "us";
      xkbOptions = "eurosign:e,caps:escape";

      # windowManager = {
      #   i3.enable = true;
      #   default = "i3";
      # };

      displayManager = {
        # job.execCmd = "";

        sessionCommands = ''
          ${pkgs.xss-lock}/bin/xss-lock -- ${pkgs.slock}/bin/slock &
        '';
      };
    };
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
