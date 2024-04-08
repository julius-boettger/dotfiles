# for study module DABANK
args@{ pkgs, variables, ... }:
{
  environment.systemPackages = with pkgs; [
    sqlite
    sqlitebrowser
    beekeeper-studio
  ];
}