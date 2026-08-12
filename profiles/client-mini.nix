{inputs, mylib, myvars, ...}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # ./common.nix
  ] ++ mylib.ls ../nixos/client-mini;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = {
      inherit inputs mylib myvars;
    };

    users.${myvars.name} = {
      programs.home-manager.enable = true;

      imports = mylib.ls ../home/client-mini;

      home = {
        username = myvars.name;
        homeDirectory = "/home/${myvars.name}";

        # For a new Home Manager profile. Preserve an older value when migrating.
        stateVersion = "26.05";
      };
    };
  };
}