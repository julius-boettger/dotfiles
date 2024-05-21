# entry point of my nixos configuration
{
  inputs = {                 
    # main inputs for packages                update channel version here vvvvv (see variables.nix for state version)
    nixpkgs.url =                         "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager = { url = "github:nix-community/home-manager?ref=release-23.11";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # for occasional unstable packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # for ./modules/studies/itsarch.nix
    nixpkgs-itsarch.url = "github:nixos/nixpkgs?rev=dd5621df6dcb90122b50da5ec31c411a0de3e538";
    # hyprland (to manage version independently of other packages)
    hyprland.url = "github:hyprwm/Hyprland?submodules=1&ref=v0.39.1";
    # shared dependencies of following inputs
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    # declarative disk management
    disko = { url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs"; };
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
    variables = import ./variables.nix;

    ### process nixosConfigs in variables.nix
    # map a high-level attribute set to a lib.nixosSystem
    mkNixosConfig = device@{
      ### required
      # name of corresponding device directory, e.g. "desktop" for ./devices/desktop/
      internalName,
      # list of other nix configuration to include, e.g. [ ./base/desktop.nix ]
      modules,
      ### optional
      # device architecture
      system ? "x86_64-linux",
      # networking hostname
      hostName ? "nixos",
      # optimize config for usage with laptop
      isLaptop ? false,
    }:
    let
      pkgs-config   = { inherit system; config.allowUnfree = true; };
      pkgs          = import inputs.nixpkgs          pkgs-config;
      pkgs-unstable = import inputs.nixpkgs-unstable pkgs-config;

      # attributes of this set can be taken as function arguments in modules like base/default.nix
      specialArgs = {
        inherit inputs variables;
        secrets = import ./secrets.nix;
        local-pkgs = (import ./pkgs) { inherit system pkgs pkgs-unstable; };
        vscode-extensions = (import inputs.nix-vscode-extensions).extensions.${system};
        # device specific variables (with weird fix for optionals)
        device = { inherit system hostName isLaptop; } // device;
        # helper functions
        getNixpkgs  = input: inputs.${input}.legacyPackages.${system};
        getPkgs     = input: inputs.${input}      .packages.${system};
        script      = pkgs.writeShellScriptBin;
        script-file = name: path: pkgs.writeShellScriptBin name (builtins.readFile(path));
      };
    in
    inputs.nixpkgs.lib.nixosSystem {
      # make specialArgs available for nixos system
      inherit system specialArgs;
      # include nix config
      modules =
        # given extra config of device
        modules ++ 
        # if device is a laptop: laptop utils
        (if isLaptop then [ ./modules/laptop-utils.nix ] else []) ++ 
        # and more...
        [
          ./base # most basic stuff
          ./devices/${internalName} # for specific device
          # make home manager available
          inputs.home-manager.nixosModules.home-manager
          # make specialArgs available for home manager
          { home-manager.extraSpecialArgs = specialArgs; }
          # overlay unstable packages to do something like pkgs.unstable.my-package
          ({ ... }: { nixpkgs.overlays = [ (final: prev: { unstable = pkgs-unstable; }) ]; })
        ];
    };
    # take a nixosConfigs list like
    # [{ internalName="desktop"; hostName="nixos"; }]
    # then maps each config to a set using internalName like
    # { "desktop"={ internalName="desktop"; hostName="nixos; }; }
    # then maps each set to a lib.nixosSystem using mkNixosConfig like
    # { "desktop"=lib.nixosSystem {...}; }
    mkNixosConfigs = nixosConfigs: 
      builtins.mapAttrs (ignored: namedConfig: mkNixosConfig namedConfig) (
        builtins.listToAttrs (
          builtins.map (config: {
            value = config;
            name = config.internalName; 
          }) nixosConfigs
        )
      );
  in
  {
    nixosConfigurations = variables.nixosConfigs { inherit mkNixosConfigs inputs; };
  };
}