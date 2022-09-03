{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs) lib;
in {
  writeVastSchema = name: attr: nixpkgs.writeText name (import ./writeVastSchema.nix args attr);
  alias = import ./alias.nix args;
}
