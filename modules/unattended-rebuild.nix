# systemd service for unattended nixos rebuilds
args@{ config, lib, pkgs, ... }:
lib.mkModule "unattended-rebuild" config {
  # avoid password prompts when rebuilding from a non-privileged user
  security.sudo.extraRules = [ {
    users = [ config.username ];
    commands = [
      { options = [ "NOPASSWD" ]; command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild"; }
      # needed for flake-rebuild-remote 
      { options = [ "NOPASSWD" ]; command = "/run/current-system/sw/bin/nix-env"; }
      { options = [ "NOPASSWD" ]; command = "/nix/store/*-nixos-system-nixos-*/bin/switch-to-configuration"; }
    ];
  } ];

  systemd.services.unattended-nixos-rebuild = {
    description = "Weekly NixOS rebuild";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = config.username;
    };

    # dont cancel execution if its rebuild modified this service 
    restartIfChanged = false;
    stopIfChanged = false;

    path = with pkgs; [
      nixos-rebuild
      git
      openssh # for git over ssh
    ];

    script = ''
      cd /etc/dotfiles || exit 1

      if [ -n "$(git status --porcelain)" ]; then
        echo "There are uncommitted changes, exiting..."
        exit 1
      fi

      git pull
      echo "Rebuilding on branch $(git branch --show-current), commit $(git rev-parse --short HEAD) \"$(git log -1 --pretty=%s)\" from $(git log -1 --date=format:'%b %d %H:%M:%S' --pretty=%cd)"

      exec /run/wrappers/bin/sudo ${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --flake .#${config.name}
    '';
  };

  systemd.timers.unattended-nixos-rebuild = {
    description = "Run NixOS rebuild weekly";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sat 03:00";
      Persistent = true; # catch up if host was off
    };
  };
}
