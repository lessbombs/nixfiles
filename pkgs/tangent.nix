# SPDX-FileCopyrightText: Mattia Nicolella <mattianicolella@gmail.com>
# SPDX-FileCopyrightText: LESS BOMBS <mail@lessbombs.com>
# SPDX-License-Identifier: MIT
# adapted from Nick1296/nur-packages
{
  appimageTools,
  fetchurl,
  stdenv,
  lib,
}:

appimageTools.wrapType2 rec {
  pname = "Tangent";
  version = "0.12.6";
  src =
    let
      arch = if (stdenv.hostPlatform.isAarch64) then "-arm64" else "";
    in
    fetchurl {
      url = "https://suchnsuch-public.s3.us-east-2.amazonaws.com/Tangent/Releases/Tangent-${version}${arch}.AppImage";
      sha256 = "sha256-jmhBRRgXSuB+NzokfWNiXM6/PHT4maB2Q+JuSNHtHJw=";
    };
  meta = {
    description = "A clean and powerful open source notes app for Mac, Windows, and Linux";
    homepage = "https://www.tangentnotes.com/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}