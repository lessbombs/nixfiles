# see also ../../home/client-full/plasma.nix

{pkgs, myvars, ... }:
{

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.plasma-login-manager = {
      enable = true;
      /*settings = {
        Wallpaper.Image = "filepath";
      }; */
    };
    displayManager.autoLogin = {
      enable = true;
      user = myvars.name;
    };
  };

  # todo: plasma isn't respecting i18n.nix -- fix should be written here or in home/client-full/plasma.nix

  # unlock login + kde wallet with luks password
  systemd.services.plasmalogin.serviceConfig.KeyringMode = "inherit";
  security.pam.services.plasmalogin-autologin.rules.auth = {
    systemd_loadkey = {
      order = 0;
      control = "optional";
      modulePath = "${pkgs.systemd}/lib/security/pam_systemd_loadkey.so";
    };
    plasmalogin = {
      order = 1;
      control = "include";
      modulePath = "plasmalogin";
    };
  };
}