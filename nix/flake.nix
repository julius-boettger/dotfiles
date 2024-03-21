{
  inputs = {                                        # update version here vvvvv
    nixpkgs.url =                         "github:nixos/nixpkgs?ref=nixos-23.11";
    home-manager = { url = "github:nix-community/home-manager?ref=release-23.11";
                     inputs.nixpkgs.follows = "nixpkgs"; };
    nixos-wsl = { url = "github:nix-community/NixOS-WSL";
                  inputs.nixpkgs.follows = "nixpkgs"; };
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  # take inputs as arguments
  outputs = inputs@{ self, ... }:
  let
    system = "x86_64-linux";

    variables = import ./variables.nix pkgs.callPackage;

    pkgs-config   = { inherit system; config.allowUnfree = true; };
    pkgs          = import inputs.nixpkgs          pkgs-config;
    pkgs-unstable = import inputs.nixpkgs-unstable pkgs-config;

    mkNixosConfiguration = { modules, hostName, firefoxProfile ? null }:
      let
        # attributes of this set can be taken as function arguments in modules like base/default.nix
        specialArgs = {
          # shared
          inherit variables;
          # device specific
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
    nixosConfigurations = {
      # "nixos" will be built by default, others have to be used like "--flake .#NAME"
      nixos = mkNixosConfiguration {
        hostName = "nixos";
        firefoxProfile = "h5hep79f.dev-edition-default";
        modules = [
          ./base/desktop.nix
          ./hosts/nixos
        ];
      };
      wsl = mkNixosConfiguration {
        hostName = "wsl";
        modules = [
          inputs.nixos-wsl.nixosModules.wsl
          ./hosts/wsl
        ];
      };
    };
  };
}