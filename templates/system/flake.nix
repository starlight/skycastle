{
  inputs.skycastle.url = github:starlight/skycastle;

  outputs = { self, nixpkgs, ... }@attrs: {
    nixosConfigurations.skycastle = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules = [ ./configuration.nix ];
    };
  };
}
