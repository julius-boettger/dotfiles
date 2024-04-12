args@{ pkgs, variables, ... }:
{
  environment.systemPackages = with pkgs; [
    ghdl
    digital
    gtkwave
  ];
}