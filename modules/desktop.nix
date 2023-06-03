{ config, pkgs, ... }:

{
  imports = [ ./base.nix ./audio.nix ];
  #options = {};

  config = {
    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}

