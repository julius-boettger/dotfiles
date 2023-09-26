# I copied this derivation from nixpkgs to be able to adjust the version more easily.

{ stdenv
, fetchurl
, makeWrapper
, copyDesktopItems
, makeDesktopItem
, jre
}:

stdenv.mkDerivation rec {
  pname = "gitnuro";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/JetpackDuba/Gitnuro/releases/download/v${version}/Gitnuro-linux-${version}-x86_64.jar";
    hash = "sha256-IWe3duiI721pCSw2o+YtFMP7VQE2kPtFN34lQrrf+uA=";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/JetpackDuba/Gitnuro/main/icons/logo.svg";
    hash = "sha256-QGJcWTSJesIpDArOWiS3Kn1iznzeMFzvqS+CuNXh3as=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall
    makeWrapper ${jre}/bin/java $out/bin/gitnuro --add-flags "-jar $src"
    install -Dm444 $icon $out/share/icons/hicolor/scalable/apps/com.jetpackduba.Gitnuro.svg
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Gitnuro";
      exec = "gitnuro";
      icon = "com.jetpackduba.Gitnuro";
      desktopName = "Gitnuro";
      categories = [ "Development" ];
      comment = "A FOSS Git multiplatform client based on Compose and JGit";
    })
  ];
}