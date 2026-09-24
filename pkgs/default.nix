{ pkgs, ... }:

with pkgs.unstable;
{
  azule = callPackage ./azule { };
  manhattan = callPackage ./manhattan { };
  motomachi-patched = callPackage ./motomachi { };
  mplus-fonts = callPackage ./mplus.nix { };
  tangent = callPackage ./tangent.nix { };
}
