{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Replace this file with the one generated for the target machine:
  #   nixos-generate-config --show-hardware-config > hosts/atlas/hardware-configuration.nix
  # The empty defaults merely allow the starter tree to evaluate on many PCs.
  boot.initrd.availableKernelModules = lib.mkDefault [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
