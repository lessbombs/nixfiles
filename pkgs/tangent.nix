# SPDX-FileCopyrightText: Mattia Nicolella <mattianicolella@gmail.com>
# SPDX-FileCopyrightText: LESS BOMBS <mail@lessbombs.com>
# SPDX-License-Identifier: MIT
# adapted from Nick1296/nur-packages
{
  appimageTools,
  fetchurl,
  stdenv,
  lib,
  makeDesktopItem,
}:

let
  pname = "tangent";
  version = "0.12.6";
  src =
    let
      arch = if (stdenv.hostPlatform.isAarch64) then "-arm64" else "";
    in
    fetchurl {
      url = "https://suchnsuch-public.s3.us-east-2.amazonaws.com/Tangent/Releases/Tangent-${version}${arch}.AppImage";
      sha256 = "sha256-jmhBRRgXSuB+NzokfWNiXM6/PHT4maB2Q+JuSNHtHJw=";
    };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  desktopItem = makeDesktopItem {
    name = "tangent";
    desktopName = "Tangent";
    comment = "Your Brain, Your Notes";
    icon = "tangent_electron";
    exec = "tangent --no-sandbox %U";
    categories = [ "Office" ];
    mimeTypes = [ "text/markdown" ];
    startupWMClass = "tangent";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D "${desktopItem}/share/applications/"* \
      -t $out/share/applications/
    cp -r ${appimageContents}/usr/share/icons $out/share/
  '';

  meta = {
    description = "A clean and powerful open source notes app for Mac, Windows, and Linux";
    homepage = "https://www.tangentnotes.com/";
    license = lib.licenses.asl20;
    mainProgram = "tangent";
    platforms = lib.platforms.linux;
  };
}