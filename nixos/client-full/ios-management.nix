{ inputs, pkgs, ... }:

{
  # Installs KDE Connect and opens its TCP/UDP port range (1714-1764).
  programs.kdeconnect.enable = true;

  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  environment.systemPackages = [
    pkgs.my.azule
    pkgs.libimobiledevice
    pkgs.ifuse
    inputs.iloader.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
