# entry point of my nixos configuration
{
  inputs = {                 
    # main inputs for packages                        update version here vvvvv
    nixpkgs.url =                         "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager = { url = "github:nix-community/home-manager?ref=release-23.11";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # for occasional unstable packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # shared dependencies of following inputs
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    # wsl utils
    nixos-wsl = { url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat"; };
    # for more vscode extensions
    nix-vscode-extensions = { url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat"; };
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
        vscode-extensions = (import inputs.nix-vscode-extensions).extensions.${system};
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