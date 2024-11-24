# build local packages
{ pkgs, ... }:
{
  easyroam         = pkgs.callPackage ./easyroam.nix         {};
  sddm-sugar-candy = pkgs.callPackage ./sddm-sugar-candy.nix {};
}