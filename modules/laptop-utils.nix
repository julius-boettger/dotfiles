# useful config / tools for laptops
args@{ pkgs, variables, secrets, ... }:
{
  # set env var to optimize config for usage with laptop
  environment.variables.IS_LAPTOP = "1";

  # enable touchpad support
  services.xserver.libinput.enable = true;

  # probably useful
  hardware.enableAllFirmware = true;

  # configure behavior when closing laptop lid
  services.logind = {
    # do nothing, you have to suspend manually
    lidSwitch       = "ignore";
    lidSwitchDocked = "ignore";
  };
}