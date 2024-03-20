{
  inputs = {                                        # update version here vvvvv
    nixpkgs.url =                         "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager = { url = "github:nix-community/home-manager?ref=release-23.11";
                     inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  # take inputs as arguments
  outputs = inputs@{ self, ... }:
  let
    system = "x86_64-linux";

    pkgs-config   = { inherit system; config.allowUnfree = true; };
    pkgs          = import inputs.nixpkgs          pkgs-config;
    pkgs-unstable = import inputs.nixpkgs-unstable pkgs-config;

    mkNixosConfiguration = { modules }: inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        inputs.home-manager.nixosModules.home-manager
        # overlay unstable packages to do something like pkgs.unstable.my-package
        ({ ... }: { nixpkgs.overlays = [ (final: prev: { unstable = pkgs-unstable; }) ]; })
      ] ++ modules;
    };
  in
  {
    nixosConfigurations = {
      # it's easiest to use the hostname of the device here 
      nixos = mkNixosConfiguration {
        modules = [ ./configuration.nix ];
      };
    };
  };
}