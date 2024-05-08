# useful config / tools for laptops
args@{ pkgs, variables, secrets, ... }:
{
  # enable touchpad support
  services.xserver.libinput.enable = true;

  # configure behavior when closing laptop lid
  services.logind = {
    # do nothing, you have to suspend manually
    lidSwitch       = "ignore";
    lidSwitchDocked = "ignore";
  };
}