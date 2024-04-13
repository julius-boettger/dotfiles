# build local packages
{ callPackage }:
{
  gitnuro                 = callPackage ./gitnuro.nix                 {};
  hyprsome                = callPackage ./hyprsome.nix                {};
  sourcegit               = callPackage ./sourcegit                   {};
  sddm-sugar-candy        = callPackage ./sddm-sugar-candy.nix        {};
  swaylock-effects        = callPackage ./swaylock-effects.nix        {};
  monokai-pro-vscode      = callPackage ./monokai-pro-vscode          {};
  hyprctl-collect-clients = callPackage ./hyprctl-collect-clients.nix {};
}