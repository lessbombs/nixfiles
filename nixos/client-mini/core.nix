{ pkgs, ... }:

{ # todo: move some settings over to /modules/nixos/common
  networking.networkmanager.enable = true;

  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
    timeout = 1;
  };
  
  boot.initrd.systemd.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
  ];

  # For a fresh 26.05 installation. On an existing machine, preserve the
  # original stateVersion from its old configuration instead of changing it.
  system.stateVersion = "26.05";
}
