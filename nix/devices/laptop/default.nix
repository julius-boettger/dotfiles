args@{ pkgs, variables, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # automatic garbage collection to free space
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-old";
  };

  # show loading animation during boot with plymouth
  boot = {
    initrd.systemd.enable = true; # run plymouth early
    plymouth.enable = true;
    plymouth.theme = "breeze";
    #plymouth.theme = "bgrt";
    #plymouth.theme = "fade-in";
    #plymouth.theme = "glow";
    #plymouth.theme = "script";
    #plymouth.theme = "solar";
    #plymouth.theme = "spinner";
    #plymouth.theme = "spinfinity";
    #plymouth.theme = "tribar";
    #plymouth.theme = "text";
  };
}
