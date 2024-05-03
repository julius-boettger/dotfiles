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
  nixosConfigs = { mkNixosConfig, inputs }: {
    desktop = mkNixosConfig {
      # device architecture
      system = "x86_64-linux";
      # name of corresponding device directory
      internalName = "desktop";
      # networking hostname
      hostName = "nixos";
      # firefox profile to customize
      firefoxProfile = "h5hep79f.dev-edition-default";
      # nix configuration to include
      modules = [ ./base/desktop.nix ];
    };
    laptop = mkNixosConfig {
      system = "x86_64-linux";
      internalName = "laptop";
      hostName = "nixos";
      firefoxProfile = "rwe6phtm.dev-edition-default";
      modules = [ ./base/desktop.nix ];
    };
    # not really a "device", i know
    wsl = mkNixosConfig {
      system = "x86_64-linux";
      internalName = "wsl";
      hostName = "wsl";
      modules = [ inputs.nixos-wsl.nixosModules.wsl ];
    };
  };
}