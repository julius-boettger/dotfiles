# config variables that are shared by all of my devices.
{
  # nixos and home-manager state version (see top of flake.nix for channel version)
  version = "24.05";
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
    }
    {
      internalName = "laptop";
      isLaptop = true;
    }
    {
          hostName = "wsl";
      internalName = "wsl";
      modules = [ inputs.vscode-server.nixosModules.default ];
    }
  ];
}