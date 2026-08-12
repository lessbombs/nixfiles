{
  description = "NixOS for the systems of LESS BOMBS!";

  outputs = inputs@{ nixpkgs, ... }:
    let
      mylib = import ./lib { inherit inputs; };
      myvars = import ./vars;
    in {
      nixosConfigurations = {

        worldlimit = mylib.mkSys {
          hostname = "worldlimit";
          system = "x86_64-linux";
          profile = "client-full";
          inherit mylib myvars;
        };

        vm-testing = mylib.mkSys {
          hostname = "vm-testing";
          system = "x86_64-linux";
          profile = "client-full";
          inherit mylib myvars;
        };
        /*
        verdantpaths = mylib.mkSys {
          hostname = "verdantpaths";
          system = "x86_64-linux";
          profile = "client-mini";
          inherit mylib myvars;
        } // extraModules = [ ../profiles/extra/gaming.nix ];
        # todo: figure out best way to declare addons to a profile, maybe /profiles/extra is stupid boilerplate

        citrinewoods = mylib.mkSys { 
          hostname = "citrinewoods";
          system = "x86_64-linux";
          profile = "client-full";
          inherit mylib myvars;
        };
        */
      };

      # todo: more elegant way of specifying formatter
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree; 
    };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    helium = { # todo: replace
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };
}
