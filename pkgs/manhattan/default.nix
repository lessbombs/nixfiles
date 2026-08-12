{ lib, stdenvNoCC }:

stdenvNoCC.mkDerivation {
  pname = "manhattan";
  version = "0.0.1";

  src = ./Manhattan.colors;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/color-schemes/Manhattan.colors
    runHook postInstall
  '';


  meta = {
    description = "BreezeDark but purple";
    homepage = "https://github.com/KDE/breeze/tree/master/colors";
    license = lib.licenses.lgpl2Plus; # inherited from BreezeDark
    platforms = lib.platforms.all;
  };
}