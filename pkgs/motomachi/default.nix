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
    hash = lib.fakeHash;
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
    hash = lib.fakeHash;
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

    mkdir -p inter/ttf inter/otf mplus motomachi

    for weight in Thin ExtraLight Light Regular Medium SemiBold Bold ExtraBold Black; do
      cp "${interStatic}/share/fonts/truetype/Inter-$weight.ttf" inter/ttf/
      cp "${interStatic}/share/fonts/opentype/Inter-$weight.otf" inter/otf/
    done

    cp -r "${mplus}/." mplus/

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
