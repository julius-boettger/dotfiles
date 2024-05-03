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
  # nixos configurations for different devices
  nixosConfigs = { mkNixosConfigs, inputs }: mkNixosConfigs [
    {
      # name of corresponding device directory
      internalName = "desktop";
      # device architecture
      system = "x86_64-linux";
      # networking hostname
      hostName = "nixos";
      # firefox profile to customize
      firefoxProfile = "h5hep79f.dev-edition-default";
      # nix configuration to include
      modules = [ ./base/desktop.nix ];
    }
    {
      internalName = "laptop";
      system = "x86_64-linux";
      hostName = "nixos";
      firefoxProfile = "rwe6phtm.dev-edition-default";
      modules = [ ./base/desktop.nix ];
    }
    {
      internalName = "wsl";
      system = "x86_64-linux";
      hostName = "wsl";
      modules = [ inputs.nixos-wsl.nixosModules.wsl ];
    }
  ];
}