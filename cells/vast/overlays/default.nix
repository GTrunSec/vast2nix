{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs;
in {
  default = import ./main.nix {inherit inputs;};
  vast = import "${inputs.vast-overlay}/nix/overlay.nix" {inputs = inputs.vast-overlay.inputs;};
}
