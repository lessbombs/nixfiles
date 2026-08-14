{ # remember to pull from nixpkgs-unstable!
  lib,
  stdenvNoCC,
  fetchgit,
  fetchFromGitHub,
  fontforge,
  installFonts,
  inter
}:

let
  # pull a newer version of M PLUS 1 (2026-04-08)
  mplus = fetchgit {
    url = "https://github.com/coz-m/MPLUS_FONTS.git";
    rev = "06feee41806add15dfc4ce3b657026bd6afeb5ea";
    rootDir = "fonts/MPLUS1";
    hash = "sha256-0DdFhVFnxsvAHxUq92WZNxVx8QgMtq8W8G11YJuf5cE=";
  };

  # we need extras/ from the inter .zip for static fonts
  interStatic = inter.overrideAttrs (_: { postPatch = ""; } );

in stdenvNoCC.mkDerivation {
  pname = "motomachi-patched";
  version = "2026-04-08";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wing-land";
    repo = "motomachi-scripts";
    rev = "29615f849b2eb7bb39db50d905eac6e0b66fd4e1";
    hash = "sha256-5vfemgNtfe3hJYa9VU1u3QyAPy2Ggc3p5fjEwHQxN/g=";
  };

  patches = [ ./motomachi.patch ];

  nativeBuildInputs = [ fontforge installFonts ];

  # timestamp from relevant MPLUS1 commit
  SOURCE_DATE_EPOCH = "1775637780";

  buildPhase = ''
    runHook preBuild

    # FontForge may consult $HOME even in command-line mode.
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"

    mkdir -p inter motomachi
    ln -s "${interStatic}/share/fonts/truetype" inter/ttf
    ln -s "${interStatic}/share/fonts/opentype" inter/otf
    ln -s "${mplus}" mplus

    fontforge -lang=py -script motomachi.py
    rm -rf inter mplus

    runHook postBuild
  '';

  meta = {
    description = "Modified Motomachi font built from more-recent Inter and M PLUS 1";
    homepage = "https://github.com/wing-land/motomachi";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
