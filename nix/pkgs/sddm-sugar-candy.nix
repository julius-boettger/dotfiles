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
    hash = "sha256-p2d7I0UBP63baW/q9MexYJQcqSmZ0L5rkwK3n66gmqM=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sddm/themes/sugar-candy
    cp -r . $out/share/sddm/themes/sugar-candy
    ln -sf /etc/dotfiles/other/sddm-sugar-candy.conf $out/share/sddm/themes/sugar-candy/theme.conf

    runHook postInstall
  '';
}