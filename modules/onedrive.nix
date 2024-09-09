# onedrive
args@{ config, lib, variables, ... }:
lib.mkModule "onedrive" config {
  services.onedrive.enable = true;

  # create config file in ~/.config
  home-manager.users.${variables.username} = { config, ... }: {
    xdg.configFile."onedrive/config".text = ''
      # try to download changes from onedrive every x seconds
      monitor_interval = "6"
      # fully scan data for integrity every x attempt of downloading (monitor_interval)
      monitor_fullscan_frequency = "50"
      # minimum number of downloaded changes to trigger desktop notification
      min_notify_changes = "1"   
      # ignore temporary stuff and weird obsidian file
      skip_file = "~*|.~*|*.tmp|.OBSIDIANTEST"
    '';
  };
}