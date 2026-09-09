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
          inherit mylib myvars;
        };

        test-client = mylib.mkSys {
          hostname = "test-client";
          system = "x86_64-linux";
          inherit mylib myvars;
        };
        /*
        verdantpaths = mylib.mkSys {
          hostname = "verdantpaths";
          system = "x86_64-linux";
          inherit mylib myvars;
        } 

        citrinewoods = mylib.mkSys { 
          hostname = "citrinewoods";
          system = "x86_64-linux";
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

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = { # todo: replace
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    iloader = {
      url = "github:nab138/iloader";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
}
