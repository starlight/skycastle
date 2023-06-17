{ config, pkgs, ... }:

{
  imports = [ ./install.nix ];
  #options = {};

  config = {
    nix.settings.auto-optimise-store = true;
    nixpkgs.config.allowUnfree = true;

    boot = {
      consoleLogLevel = 0;
      kernel.sysctl = {
        "vm.max_map_count" = 262144;
        "vm.swappiness" = 10;
        "fs.inotify.max_user_watches" = 524288;
      };
      kernelParams = [ "quiet" "threadirqs" ];
      tmp.useTmpfs = true;
    };

    environment.systemPackages = with pkgs; 
    let
      skycastle-rebuild = writeShellScriptBin "skycastle-rebuild" ''
        nix flake update /etc/nixos || exit 1
        exec nixos-rebuild switch --flake /etc/nixos#skycastle $@
      '';
      skycastle-iso = writeShellScriptBin "skycastle-iso" ''
        ISOTMP="$(mktemp -dq /var/tmp/skycastle-iso-XXXXXXXX)"
        cd $ISOTMP
        echo "generating image '$ISOTMP'"
        exec nix build github:starlight/skycastle#nixosConfigurations.install-iso.config.system.build.isoImage $@
      '';
    in [
      coreutils
      duperemove
      git
      psmisc
      zsh
      compsize
      skycastle-rebuild
      skycastle-iso
    ];

    fileSystems."/".options = [ "compress=zstd" ];

    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    services = {
      haveged.enable = true;
      journald.extraConfig = ''
      Storage=volatile
    '';
      btrfs.autoScrub = {
        enable = true;
        fileSystems = [ "/" ];
      };
    };

    users = {
      defaultUserShell = "/run/current-system/sw/bin/zsh";
      mutableUsers = true;
    };
    systemd = {
      tmpfiles.rules = [
        "d /run/cache/ 1771 - users"
        "d /var/config/ 1771 - users 26w"
        "d /var/state/ 1771 - users 4w"
        "e /var/tmp/ - - - 4w"
      ];
    };
    security.pam.makeHomeDir.skelDirectory = "/etc/skel";

  };
}

