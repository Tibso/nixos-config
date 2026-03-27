{ pkgs ? import <nixpkgs> {} }:

let
  version = "1.9.4";
  src = pkgs.fetchurl {
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
  gemalto-middleware = pkgs.stdenv.mkDerivation {
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
    nativeBuildInputs = with pkgs; [
      dpkg
      qt5.wrapQtAppsHook
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
    '';
  };

  luxtrustModule = pkgs.stdenvNoCC.mkDerivation {
    name = "luxtrust-module";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/etc/pkcs11/modules
      echo "module: /usr/lib/pkcs11/libgclib.so" > $out/etc/pkcs11/modules/luxtrust.module
    '';
  };

  openconnect-via-luxtrust = pkgs.writeShellApplication {
    name = "openconnect-via-luxtrust.sh";
    text = ''
      PUB=$(p11tool --list-all --only-urls "pkcs11:token=LuxTrustV5;object=User%20Cert%20Auth;type=public")
      PRV=''${PUB//public/private}
      openconnect --disable-ipv6 -c "''${PUB}" -k "''${PRV}" "''${1:?Usage: $0 <vpn-url>}"
    '';
  };
in
pkgs.buildFHSEnv {
  name = "openconnect-via-luxtrust";
  targetPkgs = pkgs: with pkgs; [
    gemalto-middleware
    luxtrustModule
    gnutls # p11tool used by openconnect so we use it instead of p11-kit
    openconnect  # includes libpcsclite
    openconnect-via-luxtrust
  ];
  runScript = "openconnect-via-luxtrust.sh";
}
