{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  patchelf,
  binutils,
  bzip2,
  coreutils,
  curl,
  findutils,
  gnugrep,
  gnused,
  gnutar,
  gzip,
  jq,
  ldid,
  libplist,
  libxml2,
  unzip,
  xmlstarlet,
  xz,
  zip,
  zstd,
}:

let
  rev = "56e805b1e1ce9ffda953484727e7d0a12cf50994";

  toolchain = fetchurl {
    url = "https://github.com/kabiroberai/darwin-tools-linux/releases/download/v2.2.1/darwin-tools-ubuntu18.04.tar.gz";
    hash = "sha256-XhIsf8+7Z16da+9rpUwoiYJtAMy5zoxDI4vBbeNFqas=";
  };

  substrate = fetchurl {
    url = "https://apt.bingner.com/debs/1443.00/mobilesubstrate_0.9.7113_iphoneos-arm.deb";
    hash = "sha256-5/+Y3mvCc90XrWyk3HHOoj2GMtj1lHiy1ei/GsE6pnM=";
  };

  substitute = fetchurl {
    url = "https://apt.bingner.com/debs/1443.00/com.ex.substitute_2.2.3_iphoneos-arm.deb";
    hash = "sha256-q1KV7WGKYppNU7/HGaamefLranfzDcnccm6vq+Xkf8I=";
  };

  runtimeDependencies = [
    binutils
    bzip2
    coreutils
    curl
    findutils
    gnugrep
    gnused
    gnutar
    gzip
    jq
    libplist
    libxml2
    unzip
    xmlstarlet
    xz
    zip
    zstd
  ];
in
stdenv.mkDerivation {
  pname = "azule";
  version = "0-unstable-2024-07-22";

  src = fetchFromGitHub {
    owner = "mpelteshki";
    repo = "Azule";
    inherit rev;
    hash = "sha256-Jnaf4eDAXcyjxsPhI218FNcvU75ovFM7ykzqo2N5JS8=";
  };

  strictDeps = true;
  dontBuild = true;
  dontStrip = true;

  # Patch only the explicitly selected Linux ELF executables below. In
  # particular, never run patchelf over the iOS Mach-O libraries in lib/.
  dontAutoPatchelf = true;

  nativeBuildInputs = [
    autoPatchelfHook
    binutils
    gnutar
    libplist
    makeWrapper
    xz
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  postPatch = ''
    # The installation and its bootstrap resources live in the immutable Nix
    # store, so upstream's git updater and adjacent downloads cannot run.
    substituteInPlace azule \
      --replace-fail \
        'if [ ! -e "$azule/lib" ] || [ ! "$(ls -A "$azule/toolchain" &>/dev/null)" ] || [ -z "$no_update_azule" ]; then' \
        'if false; then' \
      --replace-fail \
        'if [[ "$(lscpu | cut -d ":" -f2 | head -1 | xargs)" == "x86_64" ]]; then' \
        'if [[ "$(uname -m)" == "x86_64" ]]; then'

    substituteInPlace modules/azule_apt \
      --replace-fail shasum sha1sum

    patchShebangs azule modules
  '';

  installPhase = ''
    runHook preInstall

    azuleRoot="$out/libexec/azule"
    install -Dm755 azule "$azuleRoot/azule"
    mkdir -p "$azuleRoot/modules"
    install -m644 modules/* -t "$azuleRoot/modules"
    install -Dm755 bin/linux/insert_dylib "$azuleRoot/bin/linux/insert_dylib"

    toolchainWork="$TMPDIR/azule-toolchain"
    mkdir -p "$toolchainWork" "$azuleRoot/toolchain/bin"
    tar -xf ${toolchain} -C "$toolchainWork"
    install -m755 \
      "$toolchainWork/linux/iphone/bin/otool" \
      "$toolchainWork/linux/iphone/bin/install_name_tool" \
      -t "$azuleRoot/toolchain/bin"
    ln -s ${lib.getExe ldid} "$azuleRoot/toolchain/bin/ldid"

    substrateWork="$TMPDIR/azule-substrate"
    mkdir -p "$substrateWork" "$azuleRoot/lib"
    pushd "$substrateWork"
    ar -x ${substrate}
    tar --lzma --strip-components 3 -xf data.tar.lzma \
      "./Library/Frameworks/CydiaSubstrate.framework" \
      "./usr/lib" \
      "./usr/include"
    rm \
      CydiaSubstrate.framework/CydiaSubstrate \
      CydiaSubstrate.framework/Headers/CydiaSubstrate.h
    install -m755 libsubstrate.dylib CydiaSubstrate.framework/CydiaSubstrate
    install -m644 substrate.h CydiaSubstrate.framework/Headers/CydiaSubstrate.h
    cp -a CydiaSubstrate.framework "$azuleRoot/lib/"
    plistutil \
      -i ${./CydiaSubstrate-Info.plist} \
      -o "$azuleRoot/lib/CydiaSubstrate.framework/Info.plist" \
      -f binary
    popd

    substituteWork="$TMPDIR/azule-substitute"
    mkdir -p "$substituteWork"
    pushd "$substituteWork"
    ar -x ${substitute}
    tar --lzma --strip-components 2 -xf data.tar.lzma "usr/lib"
    install -m755 libsubstitute.dylib "$azuleRoot/lib/libsubstitute.dylib"
    popd

    autoPatchelf \
      "$azuleRoot/bin/linux/insert_dylib" \
      "$azuleRoot/toolchain/bin/otool" \
      "$azuleRoot/toolchain/bin/install_name_tool"

    makeWrapper "$azuleRoot/azule" "$out/bin/azule" \
      --prefix PATH : ${lib.makeBinPath runtimeDependencies}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ patchelf ];

  installCheckPhase = ''
    runHook preInstallCheck

    for binary in \
      "$out/libexec/azule/bin/linux/insert_dylib" \
      "$out/libexec/azule/toolchain/bin/otool" \
      "$out/libexec/azule/toolchain/bin/install_name_tool"; do
      patchelf --print-interpreter "$binary" | grep -q '^/nix/store/'
    done

    if grep -aFq '/nix/store/' \
      "$out/libexec/azule/lib/libsubstitute.dylib" \
      "$out/libexec/azule/lib/CydiaSubstrate.framework/CydiaSubstrate"; then
      echo "Nix store reference found in an iOS Mach-O library" >&2
      exit 1
    fi

    runHook postInstallCheck
  '';

  meta = {
    description = "CLI for injecting jailbreak tweaks into jailed iOS apps";
    homepage = "https://github.com/mpelteshki/Azule";
    license = with lib.licenses; [
      bsd3
      unfreeRedistributable
    ];
    mainProgram = "azule";
    platforms = [ "x86_64-linux" ];
  };
}
