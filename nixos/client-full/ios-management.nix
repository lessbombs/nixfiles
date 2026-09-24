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

    postPatch = (old.postPatch or "") + ''
      # package.json was updated without synchronizing bun.lock's workspace ranges.
      ${pkgs.yq-go}/bin/yq -o=json -i \
        '.workspaces[""].dependencies = load("package.json").dependencies |
         .workspaces[""].devDependencies = load("package.json").devDependencies' \
        bun.lock
    '';
  });
in
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
    iloader
  ];
}
