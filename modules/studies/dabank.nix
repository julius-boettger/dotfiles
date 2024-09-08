args@{ pkgs, variables, ... }:
{
  environment.systemPackages = with pkgs; [
    sqlitebrowser
  ];
}