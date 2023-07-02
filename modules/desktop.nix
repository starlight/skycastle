{ config, pkgs, ... }:

{
  imports = [ ./minimal.nix ./bspwm.nix ];
  #options = {};

  config = {
    services.xserver = {
      enable = true;
      displayManager.startx.enable = true;
      #desktopManager.xterm.enable = true;
    };
    environment.systemPackages = with pkgs; [
      #polybar
      firefox
    ];
  };
}

