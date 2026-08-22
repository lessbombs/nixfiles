# configurations for input devices and display color profiles
{ pkgs, myvars, ... }:
let
  iccProfile = ./BOE0CB4.icm;
in {
  home-manager.users.${myvars.name}.programs.plasma = {

    # icc profile from notebookcheck.net/Framework-Laptop-13-5-Core-Ultra-7-review-New-2-8K-120-Hz-display-with-Arc-8-graphics.874187.0.html
    # it's ok. better than how the display shipped at least
    startup.startupScript.setIccProfile = {
      text = ''
        ${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor \
          "output.eDP-1.iccprofile.${iccProfile}" \
          "output.eDP-1.colorProfileSource.ICC"
      '';
    };

    input.touchpads = [
      {
        name = "PIXA3854:00 093A:0274 Touchpad";
        vendorId = "093a";
        productId = "0274";
        naturalScroll = true;
        accelerationProfile = "none";
        tapAndDrag = false;
        rightClickMethod = "twoFingers";
        # Plasma defaults to 0.3; use a slightly slower speed.
        scrollSpeed = 0.25;
      }
    ];
  };
}