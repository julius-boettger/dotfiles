# config variables that are shared by all of my devices.
{ callPackage }:
{
  # nixos and home-manager state version
  version = "23.11";
  # username and displayname of only user
  username = "julius";
  displayname = "Julius";
  # global git config
  git.name = "julius-boettger";
  git.email = "julius.btg@proton.me";
  # nixos configurations for different devices
  nixosConfigs = { mkNixosConfig, inputs }: {
    # "desktop" will be built by default
    desktop = mkNixosConfig {
      # networking hostname
      hostName = "nixos";
      # firefox profile to customize
      firefoxProfile = "h5hep79f.dev-edition-default";
      # nix configuration to include
      modules = [
        ./base/desktop.nix
        ./hosts/desktop
      ];
    };
    laptop = mkNixosConfig {
      hostName = "nixos";
      firefoxProfile = "rwe6phtm.dev-edition-default";
      modules = [
        ./base/desktop.nix
        ./hosts/laptop
      ];
    };
    # not really a "device", i know
    wsl = mkNixosConfig {
      hostName = "wsl";
      modules = [
        inputs.nixos-wsl.nixosModules.wsl
        ./hosts/wsl
      ];
    };
  };
  # include other expressions
  secrets = import ./secrets.nix;
  pkgs = callPackage (import ./pkgs) {};
}