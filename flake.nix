{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    haskell-flake.url = "github:srid/haskell-flake";
    nixpkgs.url = "github:nixos/nixpkgs/75a52265bda7fd25e06e3a67dee3f0354e73243c";
    systems.url = "github:nix-systems/default";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake { inputs = inputs // { inherit (inputs) nixpkgs nixpkgs-latest; }; } {
      systems = import inputs.systems;
      imports = [inputs.haskell-flake.flakeModule];

      perSystem = {
        self',
        pkgs,
        lib,
        config,
        ...
      }: {
        haskellProjects.default = {
          basePackages = pkgs.haskell.packages.ghc928;
          packages = {
            hspec.source = "2.10.10";
          };
          settings = {
            servant.jailbreak = true;
          };
      };
        packages.default =  self'.packages.servant-docs-simple;
      };
    };
}