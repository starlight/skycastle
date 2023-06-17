{ config, pkgs, ... }:

{
  # imports = [];
  # options = {};

  config = {
    environment.systemPackages = with pkgs; [ zsh ];
    users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  };
}

