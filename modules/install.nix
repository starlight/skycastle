{ config, pkgs, ... }:

{
  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages =
      let
        skycastle-generate-config = pkgs.writeShellScriptBin "skycastle-generate-config" ''
          mkdir -p /mnt/etc/nixos || exit 1
          cd /mnt/etc/nixos || exit 1
          nix flake init -t github:starlight/skycastle#nixos || exit 1
          exec nixos-generate-config --root /mnt $@
        '';
        skycastle-install = pkgs.writeShellScriptBin "skycastle-install" ''
          exec nixos-install --flake /mnt/etc/nixos#skycastle $@
        '';
      in [
        skycastle-generate-config
        skycastle-install
      ];

    programs.vim.defaultEditor = true;
  };
}

