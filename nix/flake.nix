{
  #description = "";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations = {
      # "nixos" is for hostname
      # use pkgs here instead?
      nixos = nixpkgs.lib.nixosSystem {
        # take away the "special args"?
        specialArgs = { inherit system; };
        modules = [
          # shorten this?
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ (final: prev: { unstable = pkgs-unstable; }) ]; })
          home-manager.nixosModules.home-manager
          ./configuration.nix
        ];
      };
    };
  };
}
