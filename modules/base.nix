{ config, pkgs, skycastle, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot = {
    tmp.useTmpfs = true;
    kernelParams = [ "quiet" "threadirqs" ];
    consoleLogLevel = 0;
    kernel.sysctl = {
      "vm.max_map_count" = 262144;
      "vm.swappiness" = 10;
      "fs.inotify.max_user_watches" = 524288;
    };
  };
  fileSystems."/".options = [ "compress=zstd" ];

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  services.haveged.enable = true;
  services.journald.extraConfig = ''
    Storage=volatile
  '';
  powerManagement.cpuFreqGovernor = "performance";

  users = {
    defaultUserShell = "/run/current-system/sw/bin/zsh";
  };

  environment.systemPackages = with pkgs; [
    git
    psmisc
    vim
    zsh
    compsize
  ];

}

