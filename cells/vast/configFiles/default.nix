{
  inputs,
  cell,
} @ args: let
  inherit (inputs) nixpkgs data-merge;
in {
  default = cell.library.toYaml (cell.config.default {
    db-directory = "/var/lib/vast";
    file-verbosity = "info";
  });

  customConfig = (import ./custom.nix args).config;
  customSystemd = (import ./custom.nix args).systemd;
}
