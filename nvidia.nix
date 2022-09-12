{ config, pkgs, ... }:

# https://nixos.wiki/wiki/Nvidia

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    prime = {
      offload.enable = true;

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # fix tearing
  # services.xserver.screenSection = ''
  #   Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
  #   Option         "AllowIndirectGLXProtocol" "off"
  #   Option         "TripleBuffer" "on"
  # '';

  #hardware.nvidiaOptimus.disable = true;
  environment.systemPackages = [ nvidia-offload ];

  services = {
    xserver = {
      # videoDrivers = [ "modesetting" "nvidia" ];
      videoDrivers = [ "nvidia" ];
      # videoDrivers = [ "intel" ];
    };
  };
}
