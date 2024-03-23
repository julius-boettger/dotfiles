# entry point of my nixos configuration
{
  inputs = {                                        # update version here vvvvv
    nixpkgs.url =                         "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager = { url = "github:nix-community/home-manager?ref=release-23.11";
                     inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL";
                  inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # for hyprland version 0.34.0
    nixpkgs-hyprland-34.url = "github:nixos/nixpkgs?ref=160b762eda6d139ac10ae081f8f78d640dd523eb";
  };

  # take inputs as arguments
  outputs = inputs@{ self, ... }:
  let
    system = "x86_64-linux";

    pkgs-config   = { inherit system; config.allowUnfree = true; };
    pkgs          = import inputs.nixpkgs          pkgs-config;
    pkgs-unstable = import inputs.nixpkgs-unstable pkgs-config;

    variables = pkgs.callPackage (import ./variables.nix) {};

    mkNixosConfig = {
      # nix configuration to include
      modules,
      # device specific variables
      hostName, firefoxProfile ? null
    }:
    let
      # attributes of this set can be taken as function arguments in modules like base/default.nix
      specialArgs = {
        # hyprland version 0.34.0
        hyprland-34-pkgs = import inputs.nixpkgs-hyprland-34 pkgs-config;
        # shared variables
        inherit variables;
        # device specific variables
        host = {
          inherit firefoxProfile;
          name = hostName;
        };
      };
    in
    inputs.nixpkgs.lib.nixosSystem {
      # make specialArgs available for nixos system
      inherit system specialArgs;
      modules = [
        # include most basic configuration
        ./base
        # make home manager available
        inputs.home-manager.nixosModules.home-manager
        # make specialArgs available for home manager
        { home-manager.extraSpecialArgs = specialArgs; }
        # overlay unstable packages to do something like pkgs.unstable.my-package
        ({ ... }: { nixpkgs.overlays = [ (final: prev: { unstable = pkgs-unstable; }) ]; })
      ] ++ modules;
    };
  in
  {
    nixosConfigurations = variables.nixosConfigs { inherit mkNixosConfig inputs; };
  };
}