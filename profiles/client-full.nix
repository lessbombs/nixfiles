{mylib, myvars, ...}:
{ 
  imports = [ ./client-mini.nix ] ++ (mylib.ls ../nixos/client-full);
  home-manager.users.${myvars.name}.imports = mylib.ls ../home/client-full;

  services.flatpak.enable = true;
}