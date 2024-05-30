# build local packages
{ system, pkgs, pkgs-unstable }:
let 
  callPackage = pkgs.callPackage;
in
{
  gitnuro            = callPackage ./gitnuro.nix          {};
  hyprsome           = callPackage ./hyprsome.nix         {};
  sddm-sugar-candy   = callPackage ./sddm-sugar-candy.nix {};
  monokai-pro-vscode = callPackage ./monokai-pro-vscode   {};
}