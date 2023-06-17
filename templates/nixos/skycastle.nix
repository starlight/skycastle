{ skycastle, ... }:

{
  imports = [ 
    skycastle.nixosModules.minimal
    ./configuration.nix
  ];
}

