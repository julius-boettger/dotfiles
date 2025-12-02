# build local packages
{ pkgs, ... }:
{
  jetbrains-gitclient = pkgs.callPackage ./jetbrains-gitclient.nix {};
}