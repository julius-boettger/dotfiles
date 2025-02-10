# file manager
args@{ config, lib, pkgs, ... }:
lib.mkModule "nautilus" config {
  environment.systemPackages = with pkgs; [
    unstable.nautilus
    sushi # thumbnails in nautilus
  ];

  # needed for trash to work in nautilus
  services.gvfs.enable = true;

  # set default application for opening directories
  xdg.mime.defaultApplications."inode/directory" = "nautilus.desktop";

  programs.nautilus-open-any-terminal = {
    enable = true;
    terminal = "alacritty";
  };
}