{
  description = "OHG Veranstaltungstechnik infrastructure flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    colmena.url = "github:zhaofengli/colmena/main";
    colmena.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";

    flake-parts.url = "github:hercules-ci/flake-parts";

    determinate.url = "github:DeterminateSystems/determinate";

    terranix.url = "github:terranix/terranix";
    terranix.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }: let
    hosts = import ./hosts;
    mkHost = import ./lib/builders/mkHost.nix {
      inherit inputs self hosts;
    };
  in
    flake-parts.lib.mkFlake {inherit inputs self;} {
      imports = [
        inputs.terranix.flakeModule
        inputs.devshell.flakeModule
        ./dev
      ];

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem = {pkgs, ...}: {
        terranix.terranixConfigurations.terranix = {
          terraformWrapper.package = pkgs.opentofu;
          extraArgs = {inherit hosts;};
          modules = [
            ./terranix
          ];
        };
      };
      flake = {lib, ...}: {
        colmenaHive = import ./lib/builders/mkColmena.nix {
          inherit inputs self hosts nixpkgs lib;
        };
        nixosConfigurations =
          lib.mapAttrs
          mkHost
          (lib.filterAttrs (_: h: h.type == "nixos") hosts);
      };
    };
}
