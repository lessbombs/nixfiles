{
  lib,
  stdenvNoCC,
  fetchgit,
  installFonts,
}:
stdenvNoCC.mkDerivation {
  pname = "mplus-fonts";
  version = "2026-04-08";

  dontInstallWebfonts = true;

  src = fetchgit {
    url = "https://github.com/coz-m/MPLUS_FONTS.git";
    rev = "06feee41806add15dfc4ce3b657026bd6afeb5ea";
    rootDir = "fonts";
    hash = "sha256-B3UsSMbHAND8gkQ0ePh9+tjAca13Uy+RDpN9XXJUIiI=";
  };

  nativeBuildInputs = [ installFonts ];

  meta = {
    description = "Nifty font family for Japanese and Latin glyphs";
    homepage = "https://mplusfonts.github.io";
    platforms = lib.platforms.all;
    license = lib.licenses.ofl;
  };
}
