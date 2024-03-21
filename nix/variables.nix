# config variables that are shared by all of my devices.
# takes pkgs.callPackage as function argument.
callPackage:
{
  secrets = import ./secrets.nix;
  # nixos and home-manager state version
  version = "23.11";
  # username and displayname of only user
  username = "julius";
  displayname = "Julius";
  # global git config
  git.name = "julius-boettger";
  git.email = "julius.btg@proton.me";
  # my own packages
  pkgs = {
    gitnuro                 = callPackage ./pkgs/gitnuro.nix                 {};
    hyprsome                = callPackage ./pkgs/hyprsome.nix                {};
    sddm-sugar-candy        = callPackage ./pkgs/sddm-sugar-candy.nix        {};
    swaylock-effects        = callPackage ./pkgs/swaylock-effects.nix        {};
    hyprctl-collect-clients = callPackage ./pkgs/hyprctl-collect-clients.nix {};
  };
}