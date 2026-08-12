{ pkgs, ... }:

with pkgs.unstable; {
  manhattan = callPackage ./manhattan {};
  motomachi = callPackage ./motomachi {};
}