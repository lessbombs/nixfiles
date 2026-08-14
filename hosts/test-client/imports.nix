{mylib, myvars, ... }:

{
  imports = [ ]
  ++ (mylib.ls ../../nixos/client-mini)
  ++ (mylib.ls ../../nixos/client-full);

  home-manager.users.${myvars.name}.imports = [ ]
  ++ (mylib.ls ../../home/client-mini)
  ++ (mylib.ls ../../home/client-full);
}