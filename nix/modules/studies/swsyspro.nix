args@{ pkgs, variables, ... }:
{
  environment.systemPackages = with pkgs; [
    jetbrains.rider
    dotnet-sdk_8
  ];
}