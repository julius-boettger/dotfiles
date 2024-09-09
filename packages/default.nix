# build local packages
{ pkgs, ... }:
{
  picom-jonaburg     = pkgs.callPackage ./picom-jonaburg.nix   {};
  sddm-sugar-candy   = pkgs.callPackage ./sddm-sugar-candy.nix {};
}