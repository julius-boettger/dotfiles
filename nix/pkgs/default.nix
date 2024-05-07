# build local packages
{ system, pkgs }:
let 
  callPackage = pkgs.callPackage;
in
{
  hyprsome                = callPackage ./hyprsome.nix                {};
  sddm-sugar-candy        = callPackage ./sddm-sugar-candy.nix        {};
  monokai-pro-vscode      = callPackage ./monokai-pro-vscode          {};
  # get architecture-specific packages from corresponding directory
  gitnuro = callPackage ./${system}/gitnuro.nix {};
}