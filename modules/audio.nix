{ config, pkgs, ... }:

{
  imports = [ ./desktop.nix ];
  # options = {};

  config = {
    powerManagement.cpuFreqGovernor = "performance";
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}

