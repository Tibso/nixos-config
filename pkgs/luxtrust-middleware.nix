{
  pkgs,
  lib,
  fetchurl,
  stdenv,
  buildFHSEnv,
  dpkg,
  autoPatchelfHook
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
      mkdir -p $out/{etc,usr,bin,lib,share}
      cp -r etc/* $out/etc/
      cp -r usr/* $out/usr/
      rm -rf $out/usr/share/{doc,pixmaps}/
      ln -s $out/usr/bin/* $out/bin/
      ln -s $out/usr/share/* $out/share/
      ln -s $out/usr/lib/* $out/lib/
      mkdir -p $out/share/icons/hicolor/48x48/apps
      cp $out/usr/share/icons/classicclient_logo.png $out/share/icons/hicolor/48x48/apps/
      substituteInPlace $out/share/applications/LinuxChangepintool.desktop \
        --replace-fail 'Icon=classicclient_logo.png' "Icon=$out/share/icons/hicolor/48x48/apps/classicclient_logo.png"
    '';
  };

  luxtrust-middleware-raw = stdenv.mkDerivation {
    pname = "${pname}-raw";
    version = "${version}";
    src = luxtrustDeb;
    buildInputs = with pkgs; [
      gemalto-middleware
      gcc.cc.lib
      freetype
      alsa-lib
      libx11
      libxext
      libxrender
      libxtst
      libxi
    ];
    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
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
        --replace-fail "Icon=/opt/LuxTrustMiddleware/LuxTrustMiddleware.png" "Icon=$out/share/icons/hicolor/256x256/apps/LuxTrustMiddleware.png"

      # add the .so where the middleware expects it
      cp ${pkgs.fontconfig.lib}/lib/libfontconfig.so $out/LuxTrustMiddleware/runtime/lib/amd64/server/
    '';
  };
in
# FHSEnv necessary as luxtrust-middleware will attempt to read gemalto-middleware files under /etc and /usr via hardcoded paths
buildFHSEnv {
  pname = "${pname}";
  version = "${version}";

  targetPkgs = pkgs: [ gemalto-middleware luxtrust-middleware-raw ];
  runScript = "LuxTrustMiddleware";

  # make the desktop item available outside of FHSEnv
  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${luxtrust-middleware-raw}/share/applications/LuxTrustMiddleware.desktop $out/share/applications/
    substituteInPlace $out/share/applications/LuxTrustMiddleware.desktop \
      --replace-fail "Exec=/opt/LuxTrustMiddleware/LuxTrustMiddleware" "Exec=$out/bin/${pname}"
  '';

  meta = with lib; {
    homepage = "https://www.luxtrust.com/en/middleware";
    # license: https://www.luxtrust.lu/downloads/middleware/eula.pdf
    license = licenses.unfree;
    mainProgram = "LuxTrustMiddleware";
    description = "Middleware for LuxTrust cards - Luxembourg qualified electronic signature / authentication system";
    categories = [ "Utility" "Security" ];
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ tibso ];
  };
}
