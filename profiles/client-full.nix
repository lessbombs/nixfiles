{mylib, myvars, ...}:
{ 
  imports = [ ./client-mini.nix ] ++ (mylib.ls ../modules/nixos/client-full);
  home-manager.users.${myvars.name}.imports = mylib.ls ../modules/home/client-full;
}