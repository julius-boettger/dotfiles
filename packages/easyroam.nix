# connect to eduroam
# copied from github:anders130/dotfiles
{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glib,
  gtk3,
  pango,
  cairo,
  harfbuzz,
  networkmanager,
  libsecret,
  libsoup_3,
  webkitgtk_4_1,
  glib-networking,
  wrapGAppsHook3,
}:
stdenv.mkDerivation rec {
  pname = "easyroam-connect-desktop";
  version = "1.3.5";

  src = fetchurl {
    url = "http://packages.easyroam.de/repos/easyroam-desktop/pool/main/e/easyroam-desktop/easyroam_connect_desktop-${version}+${version}-linux.deb";
    hash = "sha256-TRzEPPjsD1+eSuElvbTV4HJFfwfS+EH+r/OhdMP8KG0=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    pango
    cairo
    harfbuzz
    libsecret
    networkmanager
    webkitgtk_4_1
    libsoup_3
    glib-networking
  ];

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/share $out/share
    mkdir -p $out/bin
    ln -s $out/share/easyroam_connect_desktop/easyroam_connect_desktop $out/bin/easyroam_connect_desktop
    runHook postInstall
  '';
}