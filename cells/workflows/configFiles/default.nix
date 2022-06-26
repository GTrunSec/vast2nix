{
  inputs,
  cell,
}: let
  inherit (inputs) nixpkgs data-merge vast2nix;
in {
  deploy = cell.library.toTOML cell.config.deploy;
  deploy-user = cell.library.toTOML cell.config.deploy-user;
}
