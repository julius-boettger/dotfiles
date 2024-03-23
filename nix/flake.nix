# entry point of my nixos configuration
{
  inputs = {                                        # update version here vvvvv
    nixpkgs.url =                         "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager = { url = "github:nix-community/home-manager?ref=release-23.11";
                     inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL";
                  inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # for hyprland 0.35.0
    nixpkgs-hyprland-35.url = "github:nixos/nixpkgs?ref=fcea2b6260dd566c28c894b4207a5f2b56c2cba3";
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
        # hyprland version 0.35.0
        hyprland-35 = (import inputs.nixpkgs-hyprland-35 pkgs-config).hyprland;
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