{
  lib,
  fetchurl,
  appimageTools,
  openal,
}:
let
  pname = "beyond-all-reason";
  version = "1.2988.0";

  src = fetchurl {
    url = "https://github.com/beyond-all-reason/BYAR-Chobby/releases/download/v${version}/Beyond-All-Reason-${version}.AppImage";
    hash = "sha256-ZJW5BdxxqyrM2TJTO0SBp4BXt3ILyi77EZx73X8hqJE=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ openal ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/beyond-all-reason.desktop -t $out/share/applications
    install -m 444 -D ${appimageContents}/beyond-all-reason.png -t $out/share/icons/hicolor/256x256/apps
    substituteInPlace $out/share/applications/beyond-all-reason.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
  '';

    meta = {
    homepage = "https://www.beyondallreason.info/";
    downloadPage = "https://www.beyondallreason.info/download";
    changelog = "https://github.com/beyond-all-reason/BYAR-Chobby/releases/tag/v${version}";
    description = "Free Real Time Strategy Game with a grand scale and full physical simulation in a sci-fi setting";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = pname;
    maintainers = with lib.maintainers; [
      kiyotoko
      tibso
    ];
  };
}
