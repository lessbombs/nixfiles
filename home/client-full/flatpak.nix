{ inputs, ... }:

{
  imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

  services.flatpak.update.auto.enable = false;
  services.flatpak.uninstallUnmanaged = true;

  services.flatpak.packages = [ ];
}