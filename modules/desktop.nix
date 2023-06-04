{ config, pkgs, ... }:

{
  imports = [ ./minimal.nix ./audio.nix ];
  #options = {};

  config = {
    services.xserver = {
      enable = true;
      windowManager.bspwm.enable = true;
      displayManager.startx.enable = true;
      desktopManager.xterm.enable = true;
    };
    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}

