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

    # lock and suspend when closing laptop lid
    services = {
      # stop default behavior
      logind = {
        lidSwitch       = "ignore";
        lidSwitchDocked = "ignore";
      };
      # run custom script
      acpid = {
        enable = true;
        lidEventCommands = ''
          PATH=/run/current-system/sw/bin
          if [[ $(awk '{print$NF}' /proc/acpi/button/lid/LID0/state) == "closed" ]]; then
            export XDG_RUNTIME_DIR="/run/user/1000"
            export WAYLAND_DISPLAY="wayland-1"
            lock-suspend
          fi
        '';
      };
    };
  };
}