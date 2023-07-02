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
        skycastle-rebuild = pkgs.writeShellScriptBin "skycastle-rebuild" ''
          nix flake update /etc/nixos || exit 1
          exec nixos-rebuild switch --flake /etc/nixos#skycastle $@
        '';
        skycastle-iso = pkgs.writeShellScriptBin "skycastle-iso" ''
          ISOTMP="$(mktemp -dq /var/tmp/skycastle-iso-XXXXXXXX)"
          cd $ISOTMP
          echo "generating image '$ISOTMP'"
          exec nix build github:starlight/skycastle#nixosConfigurations.install-iso.config.system.build.isoImage $@
        '';
      in [
        skycastle-generate-config
        skycastle-install
        skycastle-iso
        skycastle-rebuild
      ];

    programs.vim.defaultEditor = true;
  };
}

