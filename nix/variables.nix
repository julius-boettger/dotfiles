# config variables that are shared by all of my devices.
{
  # nixos and home-manager state version (see top of flake.nix for channel version)
  version = "23.11";
  # use --impure for flake-rebuild by default
  allowImpureByDefault = true; # currently needed for vscodium extensions
  # username and displayname of only user
  username = "julius";
  displayname = "Julius";
  # global git config
  git.name = "julius-boettger";
  git.email = "julius.btg@proton.me";
  
  ### nixos configurations for different devices
  # documentation for possible attributes and their meanings
  # in flake.nix near "mkNixosConfig = device@{"
  nixosConfigs = { mkNixosConfigs, inputs }: mkNixosConfigs [
    {
      internalName = "desktop";
      system = "x86_64-linux";
      hostName = "nixos";
      firefoxProfile = "h5hep79f.dev-edition-default";
      modules = [ ./base/full.nix ];
    }
    {
      internalName = "laptop";
      system = "x86_64-linux";
      hostName = "nixos";
      firefoxProfile = "rwe6phtm.dev-edition-default";
      showBatteryIndicator = true;
      modules = [ ./base/gui ];
    }
    {
      internalName = "wsl";
      system = "x86_64-linux";
      hostName = "wsl";
      modules = [
        ./base/cli/full.nix
        inputs.nixos-wsl.nixosModules.wsl
      ];
    }
  ];
}