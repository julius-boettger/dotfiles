# useful config for laptops
args@{ config, lib, pkgs, variables, ... }:
{
  options.local.base.laptop.enable = lib.mkEnableOption "whether to enable laptop config";

  config = lib.mkIf config.local.base.laptop.enable {

    local = {
      base.gui.enable = true;
      plymouth.enable = true;
    };

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

    environment.systemPackages = with pkgs; [
      acpi # get battery info like remaining time to (dis)charge
      brightnessctl # control display brightness
      local.easyroam # connect to eduroam
    ];

    # autologin hyprland
    services.displayManager.sddm.settings.Autologin = {
      User = variables.username;
      Session = "hyprland.desktop";
    };

    # set brightness to 0 while lid is closed
    services.acpid = {
      enable = true;
      lidEventCommands = ''
        PATH=/run/current-system/sw/bin
        if [[ $(awk '{print$NF}' /proc/acpi/button/lid/LID0/state) == "closed" ]]; then
          # save current brightness and set to 0
          brightnessctl -s
          brightnessctl s 0
        else
          # restore saved brightness
          brightnessctl -r
        fi
      '';
    };
  };
}