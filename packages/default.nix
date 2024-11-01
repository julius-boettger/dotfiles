# build local packages
{ pkgs, ... }:
{
  easyroam         = pkgs.callPackage ./easyroam.nix         {};
  picom-jonaburg   = pkgs.callPackage ./picom-jonaburg.nix   {};
  sddm-sugar-candy = pkgs.callPackage ./sddm-sugar-candy.nix {};
}