{ pkgs, ... }:

with pkgs.unstable; {
  manhattan = callPackage ./manhattan {};
  motomachi-patched = callPackage ./motomachi {};
  mplus-fonts = callPackage ./mplus.nix {};
  tangent = callPackage ./tangent.nix {};
}