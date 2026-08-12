{ stdenvNoCC }:

stdenvNoCC.mkDerivation { # it's just breeze dark with purple highlights.
  pname = "manhattan";
  version = "0.0.1";

  src = ./Manhattan.colors;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 $src $out/share/color-schemes/Manhattan.colors
    runHook postInstall
  '';
}