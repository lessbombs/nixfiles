{ inputs }:
{
  mkSys = {
    hostname,
    system,
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

      ] ++ (mylib.ls (../hosts + "/${hostname}")) ++ extraModules;
  };

  ls = dir: builtins.map (f: (dir + "/${f}")) (builtins.attrNames (builtins.readDir dir));
}

