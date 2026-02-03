{
  pkgs,
  lib,
  fetchurl,
  stdenv,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
}:
let
  pname = "luxtrust-middleware";
  version = "1.9.4";

  src = fetchurl {
    url = "https://gitlab.com/LuxTrustPublic/middleware/-/raw/main/LuxTrust_Middleware_${version}_Debian_64bit.tar.gz";
    hash = "sha256-2pxqdWTyCsUg3AlMr2NNdToNOCDYORB2jT0M0Y3cM8c=";
  };

  extracted-debs = pkgs.runCommand "extract-debs" {
    buildInputs = [ pkgs.gnutar ];
  } ''
    mkdir -p $out
    tar -xzf ${src} -C $out
  '';

  gemaltoDeb = extracted-debs + "/Gemalto_Middleware_Debian_64bit_7.5.0-b01.05.deb";
  luxtrustDeb = extracted-debs + "/${pname}-${version}-64.deb";

  gemalto-middleware = stdenv.mkDerivation {
    pname = "libclassicclient";
    version = "7.5.0";
    src = gemaltoDeb;
    buildInputs = with pkgs; [
      atk
      gcc.cc.lib
      gdk-pixbuf
      glib
      gtk2
      pcsclite
      libsForQt5.qt5.qtbase
    ];
    nativeBuildInputs = [
      dpkg
      pkgs.qt5.wrapQtAppsHook
      autoPatchelfHook
    ];
    unpackPhase = ''
      dpkg-deb -x ${gemaltoDeb} .
    '';
    installPhase = ''
      mkdir -p $out/{bin,ClassicClient,lib,share/icons/hicolor/48x48/apps,xdg}
      cp -r usr/bin/* $out/bin/
      cp -r etc/ClassicClient/* $out/ClassicClient/
      cp -r usr/lib/* $out/lib/
      cp -r usr/share/* $out/share/
      rm -rf $out/share/{doc,pixmaps}/
      mv $out/share/icons/classicclient_logo.png $out/share/icons/hicolor/48x48/apps/
      substituteInPlace $out/share/applications/LinuxChangepintool.desktop \
        --replace-fail 'Icon=classicclient_logo.png' "Icon=$out/share/icons/hicolor/48x48/apps/classicclient_logo.png"
    '';
  };
in
stdenv.mkDerivation {
  pname = "${pname}";
  version = "${version}";
  src = luxtrustDeb;
  buildInputs = with pkgs; [
    gemalto-middleware
    jdk17
    pcsclite
    gcc.cc.lib
    freetype
    alsa-lib
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
  ];
  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];
  unpackPhase = ''
    dpkg-deb -x ${luxtrustDeb} .
  '';
  installPhase = ''
    mkdir -p $out/{bin,LuxTrustMiddleware,share/{applications,icons/hicolor/256x256/apps}}
    cp -r opt/LuxTrustMiddleware/* $out/LuxTrustMiddleware/
    ln -s $out/LuxTrustMiddleware/LuxTrustMiddleware $out/bin/LuxTrustMiddleware
    mv $out/LuxTrustMiddleware/LuxTrustMiddleware.desktop $out/share/applications/
    mv $out/LuxTrustMiddleware/LuxTrustMiddleware.png $out/share/icons/hicolor/256x256/apps/
    substituteInPlace $out/share/applications/LuxTrustMiddleware.desktop \
      --replace-fail 'Exec=/opt/LuxTrustMiddleware/LuxTrustMiddleware' "Exec=$out/bin/LuxTrustMiddleware" \
      --replace-fail 'Icon=/opt/LuxTrustMiddleware/LuxTrustMiddleware.png' "Icon=$out/share/icons/hicolor/256x256/apps/LuxTrustMiddleware.png"
  '';
  postFixup = ''
    wrapProgram $out/bin/LuxTrustMiddleware \
      --set JAVA_HOME ${pkgs.jdk17} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.jdk17 pkgs.pcsclite ]}
  '';

  meta = {
    homepage = "https://www.luxtrust.com/en/middleware";
    # license: https://www.luxtrust.lu/downloads/middleware/eula.pdf
    license = lib.licenses.unfree;
    description = "Middleware for LuxTrust cards - Luxembourg qualified electronic signature / authentication system";
    categories = [ "Utility" "Security" ];
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ tibso ];
  };
}
