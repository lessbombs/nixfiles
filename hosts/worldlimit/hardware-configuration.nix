{ config, lib, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.framework-intel-core-ultra-series1
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel= {
    npu.enable = true;
    updateMicrocode = lib.mkDefault 
      config.hardware.enableRedistributableFirmware;
  };

  hardware.bluetooth.enable = true;
  hardware.framework.laptop13.audioEnhancement.enable = true;
  services.thermald.enable = true;
  zramSwap.enable = true; # todo: prob need to look into more settings for this

}
