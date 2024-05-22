# build local packages
{ system, pkgs, pkgs-unstable }:
let 
  callPackage = pkgs.callPackage;
  gitnuro-x86 = callPackage ./gitnuro-x86.nix {};
in
{
  hyprsome           = callPackage ./hyprsome.nix         {};
  sddm-sugar-candy   = callPackage ./sddm-sugar-candy.nix {};
  monokai-pro-vscode = callPackage ./monokai-pro-vscode   {};
  # architecture-specific packages
  gitnuro = if system == "x86_64-linux" then
      gitnuro-x86
    else if system == "aarch64-linux" then
      (gitnuro-x86.overrideAttrs (pkg: { src = pkgs.fetchurl {
        url = "https://github.com/JetpackDuba/Gitnuro/releases/download/v${pkg.version}/Gitnuro-linux-arm_aarch64-${pkg.version}.jar";
        hash = "sha256-6TRQfIhaKBjNPn3tEVWoUF92JAmwlHUtQZE8gKEZ/ZI=";
      }; } ) )
    else null;
}