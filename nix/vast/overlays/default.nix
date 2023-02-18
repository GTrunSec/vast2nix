{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  default = import ./main.nix {inherit inputs;};
}
