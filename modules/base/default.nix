{ ... }:
{
  imports = [
    ./cli # this is the only module without an enable option, as it
          # contains the most basic configuration every device should have
    ./cli/full.nix
    ./gui
    ./gui/full.nix
  ];
}