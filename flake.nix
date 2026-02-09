# entry point of my nixos configuration
{
  inputs = {                 
    ### main package and option sources (also see stateVersion below in this file)
    #                                     update channel version here vvvvv 
    nixpkgs.url =                         "github:nixos/nixpkgs/nixos-25.11";
    home-manager = { url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # for occasional unstable packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs to avoid expensive cache misses of couchdb and dependencies on aarch64
    couchdb-aarch64-nixpkgs.url = "github:nixos/nixpkgs?rev=eb0e0f21f15c559d2ac7633dc81d079d1caf5f5f";

    ### other
    # hyprland (to manage version independently of other packages)
    hyprland.url =      "github:hyprwm/Hyprland/v0.53.1";
    # hyprland plugin with matching version     |||||||
    # for better multi-monitor workspaces       |||||||
    hyprsplit = { url ="github:shezdy/hyprsplit/v0.53.1";
      inputs.hyprland.follows = "hyprland";  };
    # secret management with sops
    sops-nix = { url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # declarative database for command-not-found
    programs-sqlite = { url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    # declarative discord config
    nixcord = { url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # zen browser (lock version as upgrade requires theming adjustments)
    zenix = { url = "github:anders130/zenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager"; };
    # host minecraft server
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";


    ### other nix-community stuff
    # has nixos config for raspberry pi
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # declarative disk management
    disko = { url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # nix user repository (more packages)
    nur = { url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # wsl utils
    nixos-wsl = { url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs"; };
    # for more vscode extensions
    nix-vscode-extensions = { url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable"; };
    # to connect vscode on windows with nixos wsl
    vscode-server = { url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs"; };

    ### self-written stuff to self-host
    # control govee rgb lamp
    lamp-server.url = "github:julius-boettger/lamp-server-rust";
    # control smart plug for reptile terrarium lamp
    terralux-backend.url = "github:solid-stack-solutions/terralux-backend";
    # host own website
    website = { url = "github:julius-boettger/website";
      inputs.nixpkgs.follows = "nixpkgs"; };
  };

  # take inputs as arguments
  outputs = inputs@{ self, ... }: {
    nixosConfigurations =
      # build a nixos configuration for each directory (device) in ./devices
      builtins.readDir ./devices
      |> builtins.attrNames # just the directory (device) names
      # map them to sets with name and value fields to later call builtins.listToAttrs
      |> map (name: {
        # name of the nixos configuration is device name
        inherit name;
        # actual configuration
        value =
        let
          # determine system arch from hardware config
          system =
            let path = ./devices/${name}/hardware-configuration.nix; in
            # default if there's no hardware config
            if !builtins.pathExists path then
              "x86_64-linux"
            else
              builtins.readFile path
              |> builtins.match ''^.*hostPlatform.*=.*"(.*)".*;.*$''
              |> builtins.head;

          # config to use for all nixpkgs
          pkgs-config = { inherit system; };

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
          specialArgs = { inherit inputs lib; };
        in
        lib.nixosSystem {
          # make specialArgs available for nixos system
          inherit system specialArgs;
          # include nix config
          modules = [
            # module definitions with some default config
            ./modules

            # for specific device
            ./devices/${name} 
            (lib.importIfExists ./devices/${name}/hardware-configuration.nix)
            (lib.importIfExists ./devices/${name}/disk-config.nix)

            # make some options available
            inputs.disko.nixosModules.disko # disk management
            inputs.nur.modules.nixos.default # NUR package overlay
            inputs.home-manager.nixosModules.home-manager

            # inline-module with options/config that need to be here
            ({ config, ... }: {
              # expose some constants as readonly options to config
              options = with lib; {
                name = mkOption {
                  type = types.str;
                  default = name;
                  description = "the name of the nixos configuration / device";
                  readOnly = true;
                };

                stateVersion = mkOption {
                  type = types.str;
                  default = "25.11"; # also see channel version at the top of this file!
                  description = "nixos and home-manager state version";
                  readOnly = true;
                };
              };

              config = {
                # make specialArgs available for home manager
                # and expose system-level config as sysconfig
                home-manager.extraSpecialArgs = specialArgs // { sysconfig = config; };

                # package overlays for stable nixpkgs
                nixpkgs.overlays = [
                  (final: prev: {
                    /*pkgs.*/unstable = pkgs-unstable;
                    /*pkgs.*/local    = pkgs-local;
                  })

                  # for specific device
                  (if builtins.pathExists ./devices/${name}/overlays.nix
                    then import ./devices/${name}/overlays.nix specialArgs
                    else _: _: {})

                  # from inputs
                  inputs.zenix.overlays.default
                  inputs.hyprland.overlays.default
                  inputs.nix-minecraft.overlays.default
                  inputs.nix-vscode-extensions.overlays.default
                ];
              };
            })
          ];
        };
      })
      # finally transform this list of configurations like
      # [ { name = "desktop"; value = <CONFIGURATION>; } ... ]
      # to the expected set like
      # { "desktop" = <CONFIGURATION>; ... }
      |> builtins.listToAttrs;
  };
}
