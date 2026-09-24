# configurations for input devices, suspend wake sources, and display color profiles
{ pkgs, myvars, ... }:
let
  iccProfile = ./BOE0CB4.icm;
in {
  # Set the kernel's per-device wake policy at boot and on hotplug/rebind.
  # These settings apply with the lid both open and closed. Match the platform
  # devices (not their ACPI companions) that actually expose power/wakeup.
  services.udev.extraRules = ''
    # Power button; internal keyboard and the touchpad's PS/2 compatibility port.
    ACTION=="add|bind|change", SUBSYSTEM=="platform", KERNEL=="PNP0C0C:00", TEST=="power/wakeup", ATTR{power/wakeup}="enabled"
    ACTION=="add|bind|change", SUBSYSTEM=="serio", KERNELS=="i8042", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"

    # Native I2C touchpad and lid switch.
    ACTION=="add|bind|change", SUBSYSTEM=="i2c", KERNEL=="i2c-PIXA3854:00", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
    ACTION=="add|bind|change", SUBSYSTEM=="platform", KERNEL=="PNP0C0D:00", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"

    # Keep USB controllers and hubs able to forward external keyboard wakeups.
    ACTION=="add|bind|change", SUBSYSTEM=="pci", DRIVER=="xhci_hcd", TEST=="power/wakeup", ATTR{power/wakeup}="enabled"
    ACTION=="add|bind|change", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{bDeviceClass}=="09", TEST=="power/wakeup", ATTR{power/wakeup}="enabled"

    # input_id identifies keyboards, including those without a USB boot interface.
    # Wake belongs to the USB device, not the input node. Capture that parent's
    # path now: RUN substitutions happen after subsequent rules have run.
    ACTION=="add|change", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT_KEYBOARD}=="1", \
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="?*", ATTRS{power/wakeup}=="enabled|disabled", \
      ENV{.KEYBOARD_WAKEUP}="/sys/bus/usb/devices/$id/power/wakeup", \
      RUN+="${pkgs.runtimeShell} -c 'echo enabled > \"$env{.KEYBOARD_WAKEUP}\"'"
  '';

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

    input.mice = [
      {
        name = "Glorious Model O";
        vendorId = "258a";
        productId = "0036";
        # Neutral pointer speed and Plasma's standard scroll-wheel speed.
        acceleration = -0.200;
        scrollSpeed = 1;
        accelerationProfile = "none";
      }
    ];
  };
}
