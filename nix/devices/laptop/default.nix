args@{ pkgs, variables, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop-utils.nix
  ];

  # automatic garbage collection to free space
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-old";
  };

  # show loading animation during boot with plymouth
  boot.initrd.systemd.enable = true; # run plymouth early
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
}
