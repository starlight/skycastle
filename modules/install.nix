{ config, pkgs, ... }:

{
  # imports = [];
  # options = {};

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    programs.vim.defaultEditor = true;
  };
}

