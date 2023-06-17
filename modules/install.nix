{ config, pkgs, ... }:

{
  # imports = [];
  # options = {};

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    programs.vim.defaultEditor = true;
    environment.systemPackages =
    let
      skycastle-generate-config = pkgs.writeShellScriptBin "skycastle-generate-config" ''
        nixos-generate-config --root /mnt || exit 1
        cd /mnt/etc/nixos || exit 1
        exec nix flake init -t github:starlight/skycastle#nixos
      '';
      skycastle-install = pkgs.writeShellScriptBin "skycastle-install" ''
        exec nixos-install --flake /mnt/etc/nixos#skycastle
      '';
    in [
      skycastle-generate-config
      skycastle-install
    ];
  };
}

