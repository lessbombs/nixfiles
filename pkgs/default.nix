{ pkgs, ... }:

with pkgs.unstable; {
  manhattan = callPackage ./manhattan {};
  motomachi-patched = callPackage ./motomachi {};
}