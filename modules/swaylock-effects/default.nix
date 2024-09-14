# wayland lockscreen
args@{ config, lib, pkgs, ... }:
lib.mkModule "swaylock-effects" config {
  environment.systemPackages = with pkgs; [
    unstable.swaylock-effects
    (lib.writeScriptFile "swaylock-effects" /etc/dotfiles/modules/swaylock-effects/swaylock-effects.sh)
    (lib.writeScript "lock-suspend"   "swaylock-effects && systemctl suspend"  )
    (lib.writeScript "lock-hibernate" "swaylock-effects && systemctl hibernate")
  ];

  # necessary!
  security.pam.services.swaylock = {};
}