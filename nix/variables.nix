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
      modules = [ ./base/full.nix ];
    }
    {
      internalName = "laptop";
      showBatteryIndicator = true;
      modules = [ ./base/gui ];
    }
    {
          hostName = "wsl";
      internalName = "wsl";
      modules = [
        ./base/cli/full.nix
        inputs.nixos-wsl.nixosModules.wsl
      ];
    }
  ];
}