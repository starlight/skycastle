{ config, pkgs, ... }:

{
  #imports = [];
  #options = {};

  config = {
    nix.settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
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

    environment.systemPackages = with pkgs; [
      coreutils
      duperemove
      git
      psmisc
      vim
      zsh
      compsize
    ];

    fileSystems."/".options = [ "compress=zstd" ];

    networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    services.haveged.enable = true;

    services.journald.extraConfig = ''
      Storage=volatile
    '';

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

