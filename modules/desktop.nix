{ config, pkgs, ... }:

{
  imports = [ ./minimal.nix ./audio.nix ];
  #options = {};

  config = {
    environment.systemPackages = with pkgs; [
      firefox
    ];
  };
}

