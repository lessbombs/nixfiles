{ inputs, pkgs, ... }:

let
  # iloader 2.3.1 omits hashes for these Git dependencies in its Nix package.
  iloader = inputs.iloader.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    cargoDeps = pkgs.rustPlatform.importCargoLock {
      lockFile = old.src + "/src-tauri/Cargo.lock";
      outputHashes = {
        "apple-codesign-0.1.0" = "sha256-1ajD3aHa6mUuMYVH8jluIh49J0vKTp4vrfX4T2i3oTg=";
        "isideload-0.3.17" = "sha256-oGE+dY68Gv1rmTSHCycakkSCMvUN9YjZHB1gJSikuho=";
      };
    };
  });
in
{
  services.usbmuxd.enable = true;

  environment.systemPackages = [
    pkgs.usbmuxd
    pkgs.libimobiledevice
    pkgs.ifuse
    iloader
  ];
}
