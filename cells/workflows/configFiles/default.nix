{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs data-merge vast2nix;
in {
  default = cell.library.toTOML cell.config.default;
  nodes-env = cell.library.toTOML cell.config.nodes-env;
}
