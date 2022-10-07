{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixpkgs) lib;
in {
  mkVastIntegation = attr: import ./mkVastIntegation.nix args attr;
}
