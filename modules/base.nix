{ config, pkgs, ... }:

{
  #imports = [];
  #options = {};

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

    users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  };
}

