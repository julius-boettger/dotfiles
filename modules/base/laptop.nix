# useful config for laptops
args@{ config, lib, ... }:
{
  options.local.base.laptop.enable = lib.mkEnableOption "whether to enable laptop config";

  config = lib.mkIf config.local.base.laptop.enable {

    local.base.gui.enable = true;

    # set env var to tell eww that this is a laptop
    environment.variables.IS_LAPTOP = 1;

    # enable touchpad support
    services.libinput.enable = true;

    # probably useful
    hardware.enableAllFirmware = true;

    # configure behavior when closing laptop lid
    services.logind = {
      # do nothing, you have to suspend manually
      lidSwitch       = "ignore";
      lidSwitchDocked = "ignore";
    };
  };
}