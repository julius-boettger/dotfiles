# useful config / tools for laptops
args@{ pkgs, variables, secrets, ... }:
{
  # enable touchpad support
  services.xserver.libinput.enable = true;

  # things to do when pressing power
  # buttons or closing laptop lid
  services.logind = {
    powerKeyLongPress = "poweroff";
    # do nothing, you have to suspend manually
    powerKey        = "ignore";
    lidSwitch       = "ignore";
    lidSwitchDocked = "ignore";
  };
}