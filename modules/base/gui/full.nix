# more gui config i don't want on every device
args@{ config, lib, pkgs, ... }:
{
  options.local.base.gui.full.enable = lib.mkEnableOption "whether to enable full gui config";

  config = lib.mkIf config.local.base.gui.full.enable {

    local.base.gui.enable = true;

    environment.systemPackages = with pkgs; [
      ### gui
      obs-studio # video recording
      onlyoffice-bin_latest # office suite
      gimp-with-plugins # image editor
      font-manager # font manager
      bottles # run windows software easily
      pitivi # video editor
      tenacity # audio recorder and editor
      ventoy # create bootable usb sticks
      usbimager # if ventoy causes problems
      darktable # photo editor and raw developer
      inkscape-with-extensions # vector graphic editor
      veracrypt # disk encryption
      freefilesync # file backup
      unstable.bruno # rest api client
      ddcutil ddcui # interact with external monitors
      # more gtk themes
      fluent-gtk-theme
      (colloid-gtk-theme.override { tweaks = [ "normal" ]; })

      ### cli
      dunst # for better notify-send with dunstify
      gphoto2fs # mount camera
    ];

    local = {
      virt-manager.enable = true;
      devtools.cpp.enable = true;
      playerctl.enable = true;
    };

    # remove background noise from mic
    programs.noisetorch.enable = true;
  };
}