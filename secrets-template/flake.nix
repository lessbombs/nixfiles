{
  description = "LESS BOMBS' extremely confidential flake (no peeking!!)";

  outputs = { public, agenix, ... }:
    let
      baseModules = [
        agenix.nixosModules.default

        ({ pkgs, ... }: {
          environment.systemPackages = [
            agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        })
      ];

      privateModules = {
        worldlimit = [ ./modules/client-full.nix ];
      };
    in {
      nixosConfigurations =
        builtins.mapAttrs
          (hostname: hostModules:
            public.nixosConfigurations.${hostname}.extendModules {
              modules = baseModules ++ hostModules;
            })
          privateModules;
  };

  inputs = {
    public.url = "github:lessbombs/nixfiles";

    nixpkgs.follows = "public/nixpkgs";
    home-manager.follows = "public/home-manager";
    
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
}
