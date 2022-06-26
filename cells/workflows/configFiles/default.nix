{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs data-merge vast2nix;
in {
  default = cell.library.toTOML cell.config.default;
  deploy-user = cell.library.toTOML cell.config.deploy-user;
}
