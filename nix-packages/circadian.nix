#################### WARNING ####################
# this package requires some external dependencies.
# just this derivation alone will not work.
# search for "circadian" in configuration.nix
{ rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage
rec {
  pname = "circadian";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "mrmekon";
    repo = "circadian";
    rev = "v${version}";
    sha256 = "ab5k/101jpuRDtD8aMBcNbOLbmUj0s9yJC7LS88oiLE=";
  };

  cargoLock.lockFile = "${src.outPath}/Cargo.lock";
}