# basic gui config (without unrelated programs)
args@{ pkgs, variables, ... }:
{
  imports = [ ./default.nix ];
}