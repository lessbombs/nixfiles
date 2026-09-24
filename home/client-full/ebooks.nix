{ inputs, pkgs, ... }:
{ 
  home.packages = [
    inputs.readest.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.calibre = {
    enable = true;
    plugins = [ ]; 
  };
}
