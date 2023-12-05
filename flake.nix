{
  nixConfig = {
    extra-substituters = ["https://dawidd6.cachix.org"];
    extra-trusted-public-keys = ["dawidd6.cachix.org-1:dvy2Br48mAee39Yit5P+jLLIUR3gOa1ts4w4DTJw+XQ="];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    hardware.url = "github:nixos/nixos-hardware";
    systems.url = "github:nix-systems/default-linux";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;
    inherit (inputs.nixpkgs) lib;
  in
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;
      flake = {
        overlays = import ./overlays;
        nixosModules = import ./modules/nixos {inherit lib;};
        homeModules = import ./modules/home-manager {inherit lib;};
        nixosConfigurations = import ./hosts {inherit inputs outputs lib;};
        homeConfigurations = import ./users {inherit inputs outputs lib;};
        hostNames = builtins.toString (builtins.attrNames outputs.hostTops);
        hostTops = inputs.nixpkgs.lib.mapAttrs (_: c: c.config.system.build.toplevel) outputs.nixosConfigurations;
      };
      perSystem = {pkgs, ...}: {
        devShells = import ./shell.nix {inherit pkgs;};
        packages = import ./pkgs {inherit pkgs;};
        formatter = inputs.treefmt.lib.mkWrapper pkgs ./treefmt.nix;
        checks = outputs.hostTops // (inputs.nixpkgs.lib.mapAttrs (_: c: c.activationPackage) outputs.homeConfigurations);
      };
    };
}
