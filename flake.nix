{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.install-iso = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./modules/skycastle.nix
      ];
    };

    nixosModules = {
      audio = ./modules/audio.nix;
      desktop = ./modules/desktop.nix;
      minimal = ./modules/minimal.nix;
      skycastle = ./modules/skycastle.nix;
    };

    templates = let
      nixosTemplate = {
        path = ./templates/nixos;
        description = "nixos system template";
        welcomeText = "nixos system applied!";
      };
    in {
      default = nixosTemplate;
      nixos = nixosTemplate;
    };
  };
}
