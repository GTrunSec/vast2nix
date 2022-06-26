{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs data-merge vast2nix;
  inherit (nixpkgs) lib;
in {
  #deploy = cell.library.toTOML cell.config.deploy;
  deploy = cell.library.toTOML cell.config.deploy-user;

  vast =
    lib.recursiveUpdate (import ./custom.nix args).config
    (lib.importJSON (inputs.cells.vast.library.toJSON inputs.lock.deploy.vast.config));
  systemd = (import ./custom.nix args).systemd;
}
