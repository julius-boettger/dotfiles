# bluetooth support including gui for configuration
args@{ config, lib, variables, ... }:
lib.mkModule "bluetooth" config {
  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Experimental = "true"; # necessary for some functionality
      FastConnectable = "true"; # connect faster but draw more power
    };
  };

  # bluetooth gui
  services.blueman.enable = true;
  home-manager.users.${variables.username} = { config, ... }: {
    # disable notifications when a device (dis)connects
    dconf.settings."org/blueman/general".plugin-list = [ "!ConnectionNotifier" ];
  };
}