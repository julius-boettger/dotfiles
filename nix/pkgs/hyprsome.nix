# https://github.com/sopa0/hyprsome
{ rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage
rec {
  pname = "hyprsome";
  version = "unstable-2023-06-08";

  src = fetchFromGitHub {
    owner = "sopa0";
    repo = "hyprsome";
    rev = "9636be05ef20fbe473709cc3913b5bbf735eb4f3";
    hash = "sha256-f4Z5gXZ74uAe770guywGIznXiI/3a/617MD2uZNQNVA=";
  };

  cargoLock.lockFile = "${src.outPath}/Cargo.lock";
}