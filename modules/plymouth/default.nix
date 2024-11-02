# prettier boot process with plymouth
args@{ config, lib, pkgs, ... }:
let
  theme =
    # built-in
    "breeze";
    # from adi1090x-plymouth-themes
    #"spin";
    #"circle";
    #"liquid";
    #"spinner_alt";
in
lib.mkModule "plymouth" config {
  boot = {
    # run plymouth early (for disk encryption password)
    initrd.systemd.enable = true;

    plymouth = {
      enable = true;
      inherit theme;
      # bigger colored logo for built-in themes
      logo = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png";
      # more themes
      /*themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ theme ];
        })
      ];*/
    };

    # show less text during boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "boot.shell_on_fail"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "rd.systemd.show_status=false"
    ];
  };
}