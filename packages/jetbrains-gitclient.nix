# jetbrains git client closed preview
# https://lp.jetbrains.com/download-git-client/
{ stdenv, fetchurl, makeWrapper, jre, makeDesktopItem }:
stdenv.mkDerivation rec {
  pname = "gitclient";
  version = "latest";

  src = fetchurl {
    name = "gitclient.tar.gz";
    url = "https://jb.gg/gitclient-tar-gz";
    sha256 = "sha256-KKe96UVgnwJ+WQwzbwGVerv9v/hgD5Fv/HD7CZ2gZmE=";
  };

  dontBuild = true; # src is built archive

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/gitclient}
    cp -r * $out/share/gitclient
    # remove bundled JRE, doesn't work on NixOS
    rm -r $out/share/gitclient/jbr
    makeWrapper $out/share/gitclient/bin/gitClient.sh $out/bin/gitClient \
      --set JAVA_HOME ${jre} \
      --prefix PATH : ${jre}/bin
    
    mkdir -p $out/share/applications
    cat > $out/share/applications/gitclient.desktop <<EOF
    [Desktop Entry]
    Name=JetBrains Git Client
    Exec=$out/bin/gitClient
    Icon=$out/share/gitclient/bin/gitClient.png
    Type=Application
    Categories=Development
    EOF
  '';
}
