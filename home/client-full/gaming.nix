{ pkgs, osConfig, ... }:

{
  # Adapted from https://github.com/ryan4yin/nix-config/blob/main/home/linux/gui/base/gaming.nix
  # Steam launch options: mangohud %command% / gamemoderun %command%
  # Lutris: enable advanced options, then set System options -> Command prefix to mangohud.
  home.packages = with pkgs; [
    mangohud
    protonplus
    winetricks
    umu-launcher
    bbe
  ];

  programs.lutris = {
    enable = true;
    defaultWinePackage = pkgs.proton-ge-bin;
    steamPackage = osConfig.programs.steam.package;
    protonPackages = [ pkgs.proton-ge-bin ];
    winePackages = with pkgs; [
      wineWow64Packages.full
    ];
    extraPackages = with pkgs; [
      winetricks
      gamescope
      gamemode
      mangohud
      umu-launcher
    ];
  };
}
