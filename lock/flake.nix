{
  inputs = {
    hunting-cells.url = "github:gtrunsec/hunting-cells";
    nixpkgs-hardenedlinux.url = "github:hardenedlinux/nixpkgs-hardenedlinux";
    nix-parsec.url = "github:nprindle/nix-parsec";
    nix-parsec.flake = false;
  };

  outputs = {self, ...}: {};
}
