{ pkgs, ... }:
{
  # not all modules, just the ones I currently use
  imports = [];

  environment.systemPackages = with pkgs; [
    zotero
  ];

  programs.ssh.extraConfig = ''
    Host gitlab.on.hs-bremen.de gitlab
      Hostname gitlab.on.hs-bremen.de
      User gitlab
      Port 222
  '';
}