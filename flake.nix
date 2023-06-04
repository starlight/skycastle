{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.install = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./modules/install.nix
      ];
    };
    nixosModules = {
      desktop = ./modules/desktop.nix;
      minimal = ./modules/minimal.nix;
    };
    templates.default = {
      path = ./templates/system;
      description = "skycastle system template";
      welcomeText = "skycastle system template applied";
    };
  };
}
