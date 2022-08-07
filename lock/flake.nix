{
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  inputs = {
    main.url = "../.";
    nixpkgs.follows = "main/nixpkgs";
  };

  inputs = {
    hunting-cells.url = "github:gtrunsec/hunting-cells";
    nixpkgs-hardenedlinux.url = "github:hardenedlinux/nixpkgs-hardenedlinux";
    nixpkgs-hardenedlinux.inputs.nixpkgs.follows = "nixpkgs";
    nix-parsec.url = "github:nprindle/nix-parsec";
    nix-parsec.flake = false;
  };

  outputs = {self, ...}: {};
}
