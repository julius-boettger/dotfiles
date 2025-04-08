# config variables that are shared by all of my devices.
{
  # nixos and home-manager state version (see top of flake.nix for channel version)
  version = "24.11";
  # use --impure for flake-rebuild by default
  allowImpureByDefault = false;
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
    { internalName = "desktop"; }
    { internalName = "laptop";  }
    { 
      internalName = "raspberry-pi";
          hostName =     "nixos-pi";
      system = "aarch64-linux";
    }
    {
      internalName = "wsl";
          hostName = "wsl";
    }
  ];
}