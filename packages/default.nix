# build local packages
{ pkgs, ... }:
{
  sddm-sugar-candy = pkgs.callPackage ./sddm-sugar-candy.nix {};
}