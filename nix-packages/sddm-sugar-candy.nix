#################### WARNING ####################
# this package requires some external dependencies.
# just this derivation alone will not work.
# search for "sddm-sugar-candy" in configuration.nix
{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation
rec {
  pname = "sddm-sugar-candy";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "Kangie";
    repo = "sddm-sugar-candy";
    rev = "v${version}";
    sha256 = "18wsl2p9zdq2jdmvxl4r56lir530n73z9skgd7dssgq18lipnrx7";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sddm/themes/sugar-candy
    cp -r . $out/share/sddm/themes/sugar-candy
    ln -sf /etc/nixos/sddm-sugar-candy/theme.conf $out/share/sddm/themes/sugar-candy

    runHook postInstall
  '';
}