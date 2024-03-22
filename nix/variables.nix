# config variables that are shared by all of my devices.
{ callPackage }:
{
  # nixos and home-manager state version
  version = "23.11";
  # username and displayname of only user
  username = "julius";
  displayname = "Julius";
  # global git config
  git.name = "julius-boettger";
  git.email = "julius.btg@proton.me";
  # include other expressions
  secrets = import ./secrets.nix;
  pkgs = callPackage (import ./pkgs) {};
}