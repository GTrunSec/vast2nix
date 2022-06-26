{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs data-merge;
  inherit (nixpkgs) lib;
in {
  default = cell.library.toYaml (cell.config.default {
    db-directory = "/var/lib/vast";
    file-verbosity = "info";
  });

  user-config =
    lib.recursiveUpdate (import ./custom.nix args).config
    (lib.importJSON (cell.library.toJSON inputs.lock.deploy.vast.config));
  user-systemd = (import ./custom.nix args).systemd;
}
