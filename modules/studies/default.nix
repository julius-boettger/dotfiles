{ pkgs, ... }:
{
  # not all modules, just the ones I currently use
  imports = [
    ./itsarch.nix
  ];

  # flash cards
  environment.systemPackages = [ pkgs.anki ];
}