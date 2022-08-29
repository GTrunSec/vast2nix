{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs) lib;
in {
  writeVastSchema = attr: import ./writeVastSchema.nix args attr;
}
