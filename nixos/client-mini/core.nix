{ pkgs, ... }:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
    timeout = 1;
  };
  
  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
  ];

  # For a fresh 26.05 installation. On an existing machine, preserve the
  # original stateVersion from its old configuration instead of changing it.
  system.stateVersion = "26.05";
}
