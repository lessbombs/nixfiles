{ lib, modulesPath, myvars, ... }:

{
  imports = [ 
      (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [ "ahci" "virtio_pci" "xhci_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  fileSystems."/home/${myvars.name}/share" = {
    device = "share";
    fsType = "virtiofs";
    options = [ "defaults" "nofail" ];
  };
}
