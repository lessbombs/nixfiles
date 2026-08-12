{ inputs }:
{
  mkSys = {
    hostname,
    system,
    profile,
    mylib,
    myvars,
    extraModules ? []
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs mylib myvars;
      };

      modules = [
        { networking.hostName = hostname; }
        
        # since we don't specify filesystems in hardware-configuration.nix
        inputs.disko.nixosModules.disko 

        (../hosts + "/${hostname}")
        (../profiles + "/${profile}.nix")
      ] ++ extraModules;
  };

  ls = dir: builtins.map (f: (dir + "/${f}")) (builtins.attrNames (builtins.readDir dir));
}

