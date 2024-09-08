# build local packages
{ system, pkgs, pkgs-unstable }:
let 
  callPackage = pkgs.callPackage;
in
{
  picom-jonaburg     = callPackage ./picom-jonaburg.nix   {};
  sddm-sugar-candy   = callPackage ./sddm-sugar-candy.nix {};
  monokai-pro-vscode = callPackage ./monokai-pro-vscode   {};
}