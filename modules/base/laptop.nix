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
      nwg-displays # control (external) display configuration
      brightnessctl # control display brightness
      (lib.writeScript "reset-monitors" ''
        # clear nwg-displays config
        > ~/.config/hypr/monitors.conf
        # fix wallpaper and window borders
        pkill swww
        swww-daemon & disown
        python /etc/dotfiles/modules/hyprland/wallpaper.py &
      '')
    ];

    # autologin hyprland
    services.displayManager.sddm.settings.Autologin = {
      User = variables.username;
      Session = "hyprland.desktop";
    };

    ### improve battery life
    services.auto-cpufreq.enable = true;
    # recommended by auto-cpufreq
    services.thermald.enable = true;
    # reference: https://github.com/AdnanHodzic/auto-cpufreq#example-config-file-contents
    services.auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        platform_profile = "low-power";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        platform_profile = "balanced";
        turbo = "auto";
      };
    };

    # suspend when closing laptop lid
    services = {
      # stop default behavior, not reliable
      logind = {
        lidSwitch       = "ignore";
        lidSwitchDocked = "ignore";
      };
      # run own script
      acpid = {
        enable = true;
        lidEventCommands = ''
          PATH=/run/current-system/sw/bin
          if [[ $(awk '{print$NF}' /proc/acpi/button/lid/LID0/state) == "closed" ]]; then
            systemctl suspend
          fi
        '';
      };
    };

    # notifications for low battery
    home-manager.users.${variables.username} = { config, ... }: {
      services.batsignal.enable = true;
    };
  };
}