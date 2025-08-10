# more gui config i don't want on every device
args@{ config, lib, pkgs, ... }:
{
  options.local.base.gui.full.enable = lib.mkEnableOption "whether to enable full gui config";

  config = lib.mkIf config.local.base.gui.full.enable {

    local = {
      base.gui.enable = true;
      steam.enable = true;
    };

    environment.systemPackages = with pkgs; [
      ### gui
      onlyoffice-bin_latest # office suite
      gimp-with-plugins # image editor
      darktable # photo editor and raw developer
      inkscape-with-extensions # vector graphic editor
      veracrypt # disk encryption
      freefilesync # file backup
      local.jetbrains-gitclient
      (prismlauncher.override { jdks = [ jdk ]; }) # minecraft
      #foliate # ebook reader
      #bottles # run windows software easily
      #usbimager # create bootable usb stick
      #obs-studio # video recording
      #font-manager # font manager
      #pitivi # video editor
      #tenacity # audio recorder and editor

      ### cli
      dunst # for better notify-send with dunstify
      gphoto2fs # mount camera
    ];
  };
}