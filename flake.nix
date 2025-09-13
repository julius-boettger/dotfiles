# entry point of my nixos configuration
{
  inputs = {                 
    # main inputs for packages                update channel version here vvvvv (see variables.nix for state version)
    nixpkgs.url =                         "github:nixos/nixpkgs?ref=nixos-25.05";
    home-manager = { url = "github:nix-community/home-manager?ref=release-25.05";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # for occasional unstable packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # has nixos config for raspberry pi
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # nixpkgs to avoid expensive cache misses of couchdb and dependencies on aarch64
    couchdb-aarch64-nixpkgs.url = "github:nixos/nixpkgs?rev=eb0e0f21f15c559d2ac7633dc81d079d1caf5f5f";
    # control govee rgb lamp
    lamp-server.url = "github:julius-boettger/lamp-server-rust";
    # control smart plug for reptile terrarium lamp
    terralux-backend.url = "github:solid-stack-solutions/terralux-backend";
    # host minecraft server
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    # hyprland (to manage version independently of other packages)
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.51.0";
    # hyprland plugin for better multi-monitor workspaces, matching hyprland version: ^v^v^v^
    hyprsplit = { url =                                  "github:shezdy/hyprsplit?ref=v0.51.0";
      inputs.hyprland.follows = "hyprland"; };
    # nix user repository (more packages)
    nur = { url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # secret management with sops
    sops-nix = { url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # host own website
    website = { url = "github:julius-boettger/website";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # declarative disk management
    disko = { url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # declarative database for command-not-found
    programs-sqlite = { url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    # wsl utils
    nixos-wsl = { url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # to connect vscode on windows with nixos wsl
    vscode-server = { url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # declarative discord config
    nixcord = { url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # for more vscode extensions
    nix-vscode-extensions = { url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    # zen browser (lock version as upgrade requires theming adjustments)
    zenix = { url = "github:anders130/zenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager"; };
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
      ### optional
      # device architecture
      system ? "x86_64-linux",
      # networking hostname
      hostName ? "nixos",
    }:
    let
      # config to use for all nixpkgs
      pkgs-config = {
        inherit system;
        config.allowUnfree = true; 

        # for open-webui on aarch64 https://github.com/NixOS/nixpkgs/issues/312068#issuecomment-2365236799
        overlays = [( _: prev: { pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [( _: python-prev: {
          rapidocr-onnxruntime = python-prev.rapidocr-onnxruntime.overridePythonAttrs (self: {
            pythonImportsCheck = if python-prev.stdenv.isAarch64 then [] else ["rapidocr_onnxruntime"];
            doCheck = !(python-prev.stdenv.isAarch64);
            meta = self.meta // { badPlatforms = []; };
          });
          chromadb = python-prev.chromadb.overridePythonAttrs (self: {
            pythonImportsCheck = if python-prev.stdenv.isAarch64 then [] else ["chromadb"];
            doCheck = !(python-prev.stdenv.isAarch64);
            meta = self.meta // { broken = false; };
          });
        })]; })];
      };

      pkgs          = import inputs.nixpkgs          pkgs-config;
      pkgs-unstable = import inputs.nixpkgs-unstable pkgs-config;
      pkgs-local    = import ./packages { inherit pkgs; };

      # add some helper functions to lib
      lib = inputs.nixpkgs.lib.extend (final: prev: inputs.home-manager.lib // {
        getNixpkgs  = input: import inputs.${input} pkgs-config;
        getPkgs     = input: inputs.${input}.packages.${system};
        writeScript     = pkgs.writeShellScriptBin;
        writeScriptFile = name: path: pkgs.writeShellScriptBin name (builtins.readFile(path));
        importIfExists  = path: if builtins.pathExists path then import path else {};
        mkModule = name: currentConfig: newConfig: {
          # apply newConfig if module is enabled in currentConfig
          options.local.${name}.enable = lib.mkEnableOption "whether to enable ${name}";
          config = lib.mkIf currentConfig.local.${name}.enable newConfig;
        };
      });

      # attributes of this set can be taken as function arguments in modules like modules/base/default.nix
      specialArgs = {
        inherit inputs variables lib;
        # device specific variables (with weird fix for optionals)
        device = { inherit system hostName; } // device;
      };
    in
    lib.nixosSystem {
      # make specialArgs available for nixos system
      inherit system specialArgs;
      # include nix config
      modules = [
        # module definitions with some default config
        ./modules
        # for specific device
        ./devices/${internalName} 
        (lib.importIfExists ./devices/${internalName}/hardware-configuration.nix)
        (lib.importIfExists ./devices/${internalName}/disk-config.nix)
        # make some options available
        inputs.disko.nixosModules.disko # disk management
        inputs.nur.modules.nixos.default # NUR package overlay
        inputs.home-manager.nixosModules.home-manager
        {
          # make specialArgs available for home manager
          home-manager.extraSpecialArgs = specialArgs;
          # package overlays (only for stable nixpkgs)
          nixpkgs.overlays = [
            (final: prev: {
              /*pkgs.*/unstable = pkgs-unstable;
              /*pkgs.*/local    = pkgs-local;
            })
            # for specific device
            (if builtins.pathExists ./devices/${internalName}/overlays.nix
              then import ./devices/${internalName}/overlays.nix specialArgs
              else _: _: {})
            # from inputs
            inputs.zenix.overlays.default
            inputs.nix-vscode-extensions.overlays.default
          ];
        }
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
