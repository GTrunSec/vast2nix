{
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  inputs = {
    hunting-cells.url = "github:gtrunsec/hunting-cells";
    nixpkgs-hardenedlinux.url = "github:hardenedlinux/nixpkgs-hardenedlinux";
  };
  outputs = {self, ...}: {};
}
