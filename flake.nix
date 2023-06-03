{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

  outputs = { self, nixpkgs }: {
    nixosModules = {
      base = ./modules/base.nix;
    };
    templates.default = {
      path = ./templates/system;
      description = "Skycastle system template";
      welcomeText = "Skycastle system template applied";
    };
  };
}
