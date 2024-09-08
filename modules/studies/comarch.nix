args@{ pkgs, variables, ... }:
{
  environment.systemPackages = with pkgs; [
    logisim-evolution
  ];
}