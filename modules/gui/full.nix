# more gui config i don't want on every device
args@{ pkgs, variables, ... }:
let
  barrierPort = args.secrets.barrier.port;
in
{
  imports = [
    ./default.nix
    ../../modules/studies
    ../../modules/virt-manager.nix
  ];

  # open port for barrier (if configured)
  networking.firewall.allowedTCPPorts =
    args.lib.mkIf (barrierPort != null) [ barrierPort ];

  environment.systemPackages = with pkgs; [
    ### gui
    obs-studio # video recording
    onlyoffice-bin_latest # office suite
    gimp-with-plugins # image editor
    font-manager # font manager
    bottles # run windows software easily
    pitivi # video editor
    tenacity # audio recorder and editor
    piper # configure gaming mice graphically with ratbagd
    protonup-qt # easy ge-proton setup for steam
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
    playerctl # pause media with mpris
    dunst # for better notify-send with dunstify
    gphoto2fs # mount camera
  ];

  ###########################################
  ###########################################
  ########### PROGRAMS / SERVICES ###########
  ###########################################
  ###########################################

  services.flatpak.enable = true;

  # for configuring gaming mice with piper
  services.ratbagd.enable = true;

  # remove background noise from mic
  programs.noisetorch.enable = true;

  # steam (PROPRIETARY)
  programs.steam = {
    enable = true;
    package = pkgs.unstable.steam;
  };
}